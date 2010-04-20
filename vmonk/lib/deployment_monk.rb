require 'rubygems'
require 'rest_connection'

class DeploymentMonk
  attr_accessor :common_inputs
  attr_accessor :variables_for_cloud
  attr_accessor :variations
  attr_reader :tag

  def from_tag
    variations = Deployment.find_by(:nickname) {|n| n =~ /^#{@tag}/ }
    puts "loading #{variations.size} deployments matching your tag"
    return variations
  end

  def initialize(tag, server_templates = [], extra_images = [])
    @clouds = [1,2,3]
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
    # only using the MCI from the first server template for now.
    st = @server_templates.first
    st.fetch_multi_cloud_images
    @images = st.multi_cloud_images

    # load additional mcis here
    #@images += extra_images

    @variables_for_cloud = { 
      1 => { "ec2_ssh_key_href" => "https://my.rightscale.com/api/acct/2901/ec2_ssh_keys/7053",
             "ec2_security_groups_href" => "https://my.rightscale.com/api/acct/2901/ec2_security_groups/6411",
             "parameters" => { "PRIVATE_SSH_KEY" => "key:publish-test:1" }},

      2 => { "ec2_ssh_key_href" => "https://my.rightscale.com/api/acct/2901/ec2_ssh_keys/198006",
             "ec2_security_groups_href" => "https://my.rightscale.com/api/acct/2901/ec2_security_groups/48972",
             "parameters" => {"PRIVATE_SSH_KEY" => "key:publish-test-eu:2"}},

      3 => { "ec2_ssh_key_href" => "https://my.rightscale.com/api/acct/2901/ec2_ssh_keys/197758",
             "ec2_security_groups_href" => "https://my.rightscale.com/api/acct/2901/ec2_security_groups/97863",
             "parameters" => { "PRIVATE_SSH_KEY" => "key:publish-test-west:3"}}
      }
  end

  def load_images(file)
    @images += JSON.parse(IO.read(file))
  end

  def generate_variations
    @images.each do |image|
      @clouds.each do |cloud|
        if @variables_for_cloud[cloud] == nil
          puts "variables not found for cloud #{cloud} skipping.."
          next
        end
        dep_tempname = "#{@tag}-#{image['name'].gsub(/ /,'_')}-#{rand(1000000)}"
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
          # need to setup the MCI afterwards, because we have a special internal call for that
          RsInternal.set_server_multi_cloud_image(server.href, image['href'])
        end
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
