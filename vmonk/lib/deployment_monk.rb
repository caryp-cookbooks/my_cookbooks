require 'rubygems'
require 'rest_connection'

class DeploymentMonk
  attr_accessor :common_inputs
  attr_accessor :variables_for_cloud
  attr_accessor :variations
  attr_reader :tag
  attr_accessor :clouds

  def from_tag
    variations = Deployment.find_by(:nickname) {|n| n =~ /^#{@tag}/ }
    puts "loading #{variations.size} deployments matching your tag"
    return variations
  end

  def initialize(tag, server_templates = [], extra_images = [])
    @clouds = [1,2,3,4]
    @cloud_names = { 1 => "ec2-east", 2 => "ec2-eu", 3 => "ec2-west", 4 => "ec2-ap"}
    #@clouds = [1]
    @tag = tag
    @variations = from_tag
    @server_templates = []
    @common_inputs = {}
    raise "Need either populated deployments or passed in server_template ids" if server_templates.empty? && @variations.empty?
    if server_templates.empty?
      puts "loading server templates from servers in the first deployment"
      @variations.first.servers.each do |s|
        server_templates << s.server_template_href.split(/\//).last.to_i
      end
    end
    server_templates.each do |st|
      @server_templates << ServerTemplate.find(st.to_i)
    end

    @image_count = 0
    @server_templates.each do |st|
      st.fetch_multi_cloud_images
      @image_count = st.multi_cloud_images.size if st.multi_cloud_images.size > @image_count
    end

    @variables_for_cloud = { 
      1 => { "ec2_ssh_key_href" => "https://my.rightscale.com/api/acct/2901/ec2_ssh_keys/7053",
             "ec2_security_groups_href" => "https://my.rightscale.com/api/acct/2901/ec2_security_groups/6411",
             "parameters" => { "PRIVATE_SSH_KEY" => "key:publish-test:1" }},

      2 => { "ec2_ssh_key_href" => "https://my.rightscale.com/api/acct/2901/ec2_ssh_keys/198006",
             "ec2_security_groups_href" => "https://my.rightscale.com/api/acct/2901/ec2_security_groups/48972",
             "parameters" => {"PRIVATE_SSH_KEY" => "key:publish-test-eu:2"}},

      3 => { "ec2_ssh_key_href" => "https://my.rightscale.com/api/acct/2901/ec2_ssh_keys/197758",
             "ec2_security_groups_href" => "https://my.rightscale.com/api/acct/2901/ec2_security_groups/97863",
             "parameters" => { "PRIVATE_SSH_KEY" => "key:publish-test-west:3"}},
      4 => { "ec2_ssh_key_href" => "https://my.rightscale.com/api/acct/2901/ec2_ssh_keys/209603",
             "ec2_security_groups_href" => "https://my.rightscale.com/api/acct/2901/ec2_security_groups/126284",
             "parameters" => { "PRIVATE_SSH_KEY" => "key:publish-test-ap:4"}}
      }
  end

  def generate_variations
    @image_count.times do |index|
      @clouds.each do |cloud|
        if @variables_for_cloud[cloud] == nil
          puts "variables not found for cloud #{cloud} skipping.."
          next
        end
        dep_tempname = "#{@tag}-#{@cloud_names[cloud]}-#{rand(1000000)}-"
        dep_image_list = []
        new_deploy = Deployment.create(:nickname => dep_tempname)
        @variations << new_deploy
        @server_templates.each do |st|
          server_params = { :nickname => "tempserver-#{st.nickname}", 
                            :deployment_href => new_deploy.href, 
                            :server_template_href => st.href, 
                            #:ec2_image_href => image['image_href'], 
                            :cloud_id => cloud, 
                            #:instance_type => image['aws_instance_type'] 
                          }
          
          server = Server.create(server_params.merge(@variables_for_cloud[cloud]))
          # since the create call does not set the parameters, we need to set them separate
          @variables_for_cloud[cloud]['parameters'].each do |key,val|
            server.set_input(key,val)
          end
         
          # uses a special internal call for setting the MCI on the server
          if st.multi_cloud_images[index]
            dep_image_list << st.multi_cloud_images[index]['name'].gsub(/ /,'_')
            use_this_image = st.multi_cloud_images[index]['href']
          else
            use_this_image = st.multi_cloud_images[0]['href']
          end
          RsInternal.set_server_multi_cloud_image(server.href, use_this_image)
        end
        new_deploy.nickname = dep_tempname + dep_image_list.uniq.join("_AND_")
        new_deploy.save
        @common_inputs.each do |key,val|
          new_deploy.set_input(key,val)
        end
      end
    end
  end

  def load_common_inputs(file)
    @common_inputs.merge! JSON.parse(IO.read(file))
  end

  def destroy_all
    @variations.each do |v|
      v.reload
      v.servers.each { |s| s.stop }
    end 
    @variations.each { |v| v.destroy }
    @variations = []
  end

  def get_deployments
    deployments = []
    @variations.each { |v| deployments << v.nickname }
    deployments 
  end

end
