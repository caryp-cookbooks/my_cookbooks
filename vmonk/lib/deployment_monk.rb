require 'rubygems'
require 'rest_connection'

class DeploymentMonk
  attr_accessor :common_inputs
  attr_accessor :variables_for_cloud
  attr_accessor :variations

  def from_tag
    puts "please setup the environment variable $DEPLOYMENTS_TAG to match your deployments" unless ENV['DEPLOYMENTS_TAG']
    variations = Deployment.find_by(:nickname) {|n| n =~ /#{ENV['DEPLOYMENTS_TAG']}/ }
    puts "loading #{variations.size} deployments matching your tag"
    return variations
  end

  def initialize(server_templates = [])
    @variations = from_tag
    @server_templates = []
    server_templates.each do |st|
      @server_templates << ServerTemplate.find(st)
    end
    # only using the MCI from the first server template for now.
    st = @server_templates.first
    # right now this is an array
    @images = st.multi_cloud_image['multi_cloud_image_ec2_cloud_settings']
    # load additional mcis here

    load_common_inputs(File.join(File.dirname(__FILE__), "..", "config", "mysql", "common_inputs.json"))

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

  def generate_variations
    ENV['DEPLOYMENTS_TAG'] ? deprefix = ENV['DEPLOYMENTS_TAG'] : deprefix = "VMONK"
    @images.each do |image|
      if @variables_for_cloud[image['cloud_id']] == nil
        puts "variables not found for cloud_id #{image['cloud_id']} skipping.."
        next
      end
      new_deploy = Deployment.create(:nickname => "#{deprefix}-#{rand(1000000000)}")
      @variations << new_deploy
      @server_templates.each do |st|
        server_params = { :nickname => "tempserver-#{st.nickname}", 
                          :deployment_href => new_deploy.href, 
                          :server_template_href => st.href, 
                          :ec2_image_href => image['image_href'], 
                          :cloud_id => image['cloud_id'], 
                          :instance_type => image['aws_instance_type'] 
                        }
        
        server = Server.create(server_params.merge(@variables_for_cloud[image['cloud_id']]))
        # since the create call does not set the parameters, we need to set them separate
        @variables_for_cloud[image['cloud_id']]['parameters'].each do |key,val|
          server.set_input(key,val)
        end
      end
      @common_inputs.each do |key,val|
        new_deploy.set_input(key,val)
      end
    end
  end

  def setup_variation_dns(dns_pool)
    @variations.each do |deployment|
    # set DNS inputs  
    end
  end

  def load_common_inputs(file)
    @common_inputs = JSON.parse(IO.read(file))
  end

  def destroy_all
    @variations.each do |v|
      v.servers.each { |s| s.stop }
    end 
    @variations.each { |v| v.destroy }
    @variations = []
  end
end
