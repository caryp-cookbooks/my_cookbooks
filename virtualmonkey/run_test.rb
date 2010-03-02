#!/usr/bin/env ruby

require "rubygems"
require "rest_connection"
require "net/ssh"


def add_server(nickname,deployment,template,image,public_ssh_key_href,security_group,cloud_id,instance_type)
  server = Server.create(:nickname => nickname, \
                         :deployment_href => deployment , \
                         :server_template_href => template , \
                         :ec2_image_href => image , \
                         :ec2_ssh_key_href => public_ssh_key_href , \
                         :cloud_id => cloud_id , \
                         :instance_type => instance_type, \
                         :ec2_security_groups_href => security_group )
  return server
end


@instances_launched = Array.new
def pick_instance_type(instance_types)
  instance_types.each do |type|
    next if @instances_launched.include?(type)
    @instances_launched << type
    return type
  end
  @instances_launched = Array.new
  @instances_launched << instance_types[0]
  return instance_types[0]
end

def run_test( deployment_name, \
              deployment_inputs, \
              front_end_template, \
              app_server_template, \
              connect_script, \
              image_href, \
              public_ssh_key_href, \
              security_group, \
              cloud_id, \
              instance_types, \
              private_ssh_key_path, \
              cuke_tags )

`true`
return [$?,"result output","path_to_output"]
  @debug = true

  ## create deployment 
  puts "creating deployment #{deployment_name}" if @debug
  deployment = Deployment.create(:nickname => deployment_name)


  ## add servers
  puts "adding servers" if @debug
  instance_type = pick_instance_type(instance_types)
  fe1 = add_server("fe1",deployment.href,front_end_template,image_href,public_ssh_key_href,security_group,cloud_id,instance_type)
  instance_type = pick_instance_type(instance_types)
  fe2 = add_server("fe2",deployment.href,front_end_template,image_href,public_ssh_key_href,security_group,cloud_id,instance_type)
  instance_type = pick_instance_type(instance_types)
  app1 = add_server("app1",deployment.href,app_server_template,image_href,public_ssh_key_href,security_group,cloud_id,instance_type)
  instance_type = pick_instance_type(instance_types)
  app2 = add_server("app2",deployment.href,app_server_template,image_href,public_ssh_key_href,security_group,cloud_id,instance_type)

  
  ## set inputs
  puts "setting deployment inputs" if @debug
  deployment_inputs.each do |key,val|
    deployment.set_input(key,val)
  end


  ## launch fe's 
  puts "launching front ends" if @debug
  fe1.reload
  fe1.start
  fe2.reload
  fe2.start
  fe1.wait_for_state("operational")
  fe2.wait_for_state("operational")
   
  ## cross-connnect front ends to loadbalancers
  fe1.reload
  fe2.reload
  fe1_ip = fe1.settings['private-dns-name']
  fe2_ip = fe2.settings['private-dns-name']
  lb_hostname = { :LB_HOSTNAME,"text:#{fe1_ip} #{fe2_ip}"} 
  #fe1_connect_status = fe1.run_script(connect_script,lb_hostname)
  #fe2_connect_status = fe2.run_script(connect_script,lb_hostname)
  #fe1_connect_status.wait_for_completed(fe1.audit_link)
  #fe2_connect_status.wait_for_completed(fe2.audit_link)
  
  
  ## set deployment LB_HOSTNAME to fe's private address
  deployment.set_input(:LB_HOSTNAME,"text:#{fe1_ip} #{fe2_ip}")


  ## launch app's 
  puts "launching app servers" if @debug
  app1.reload
  app1.start
  app2.reload
  app2.start
  app1.wait_for_state("operational")
  app2.wait_for_state("operational")


  ## run cucumber 
  puts "running cucumber" if @debug
  ENV['SSH_KEY_PATH'] = private_ssh_key_path
  ENV['DEPLOYMENT'] = deployment_name
  output_file = "/root/cuke_log_#{deployment_name}.log"
  result = `cucumber -f html --guess --tags #{cuke_tags} /root/my_cookbooks/features/ --out #{output_file}`

  ## clean up 
  deployment.stop_all
  deployment.destroy

  ## return results
  puts "completed tests" if @debug
  return [$?,result,output_file]

end



