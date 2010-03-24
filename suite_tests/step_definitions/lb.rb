require "rubygems"
require "ruby-debug"
require "rest_connection"
require "net/ssh"

Given /^A deployment with frontends$/ do
  puts "entering :A deployment with frontends"
  @servers.each { |s| s.settings }

end

When /^I cross connect the frontends$/ do
  puts "entering :I cross\-connect the frontends"
  @statuses = Array.new 
  st = ServerTemplate.find(@frontends.first.server_template_href)
  script_to_run = st.executables.detect { |ex| ex.name =~  /LB [app|mongrels]+ to HA proxy connect/i }
  raise "Could not find script" unless script_to_run
  @frontends.each { |s| @statuses << s.run_executable(script_to_run) }
  puts "exiting :I cross\-connect the frontends"
end

Then /^the cross connect script completes successfully$/ do
  @statuses.each_with_index { |s,i| s.wait_for_completed(@frontends[i].audit_link) }
end

Then /^I should see all servers in the haproxy config$/ do
  puts "entering :I should see all servers in the haproxy config"
  @app_server_ips = Array.new
  @appservers.each { |app| @app_server_ips << app['private-ip-address'] }
  @frontends.each { |fe| @app_server_ips << fe['private-ip-address'] }
  @frontends.each do |fe|
    fe.settings
    #fe.reload
    haproxy_config = fe.spot_check_command('cat /home/haproxy/rightscale_lb.cfg | grep server')
    @app_server_ips.each { |ip|  haproxy_config.to_s.should include(ip) }
  end
  puts "Exiting from :I should see all servers in the haproxy config"
end

Then /^I should see all app servers in the haproxy config$/ do
  puts "entering :I should see all app servers in the haproxy config"
  @app_server_ips = Array.new
  @appservers.each { |app| @app_server_ips << app['private-ip-address'] }
  @frontends.each do |fe|
    fe.settings
    haproxy_config = fe.spot_check_command('cat /home/haproxy/rightscale_lb.cfg | grep server')
    @app_server_ips.each { |ip|  haproxy_config.to_s.should include(ip) }
  end
  puts "Exiting from :I should see all app servers in the haproxy config"
end

Then /^I should see all servers being served from haproxy$/ do
  puts "entering :I should see all servers being served from haproxy"
  @frontends.each do |fe|
    ip_list = @app_server_ips.clone
    ip_list.size.times do 
      cmd = "curl -q #{fe['dns-name']}/serverid/ 2> /dev/null | grep ip= | sed 's/^ip=//' | sed 's/;.*$//'"
      puts cmd
      serverip = `#{cmd}`.chomp
      puts "serverip = #{serverip.inspect}"
      ip_list.delete serverip 
      puts "ip_list.inspect = #{ip_list.inspect}"
    end
    raise "Did not see all servers being served by haproxy!!!" unless ip_list.empty?
  end
end


When /^I restart haproxy on the frontends$/ do
  @frontends.each_with_index do |server,i|
    response = server.spot_check_command?('service haproxy restart')
    raise "Haproxy restart failed" unless response
  end
end

Then /^haproxy status should be good$/ do
  if @servers_os.first == "ubuntu"
    haproxy_check_cmd = "service haproxy status"
  else
    haproxy_check_cmd = "service haproxy check"
  end
  @frontends.each_with_index do |server,i|
    response = server.spot_check_command?(haproxy_check_cmd)
    raise "Haproxy check failed" unless response
  end
end

When /^I restart apache on all servers$/ do
  puts "entering :I restart apache on all servers"
  @statuses = Array.new
  st = ServerTemplate.find(@servers.first.server_template_href)
  script_to_run = st.executables.detect { |ex| ex.name =~  /WEB apache \(re\)start v2/i }
  raise "Script not found" unless script_to_run
  @frontends.each { |s| @statuses << s.run_executable(script_to_run) }
  @appservers.each { |s| @statuses << s.run_executable(script_to_run) }
  puts "exiting :I restart apache on all servers"
end

Then /^apache status should be good$/ do
  if @servers_os.first == "ubuntu"
    apache_status_cmd = "apache2ctl status"
  else
    apache_status_cmd = "service httpd status"
  end
  @servers.each_with_index do |server,i|
    response = server.spot_check_command?(apache_status_cmd)
    raise "Apache status failed" unless response
  end
end

When /^I restart apache on the frontends$/ do
  puts "entering :I restart apache on the frontends"
  @statuses = Array.new
  st = ServerTemplate.find(@frontends.first.server_template_href)
  script_to_run = st.executables.detect { |ex| ex.name =~  /WEB apache \(re\)start v2/i }
  raise "Script not found" unless script_to_run
  @frontends.each { |s| @statuses << s.run_executable(script_to_run) }
  puts "exiting :I restart apache on the frontends"
end

Then /^apache status should be good on the frontends$/ do
  if @servers_os.first == "ubuntu"
    apache_status_cmd = "apache2ctl status"
  else
    apache_status_cmd = "service httpd status"
  end
  @frontends.each_with_index do |server,i|
    response = server.spot_check_command?(apache_status_cmd)
    raise "Apache status failed" unless response
  end
end

When /^I restart mongrels on all servers$/ do
  puts "entering :I restart mongrels on all servers"
  @statuses = Array.new
  st = ServerTemplate.find(@servers.first.server_template_href)
  script_to_run = st.executables.detect { |ex| ex.name =~  /RB mongrel_cluster \(re\)start v1/i }
  raise "Script not found" unless script_to_run
  @frontends.each { |s| @statuses << s.run_executable(script_to_run) }
  puts "exiting :I restart mongrels on all servers"
end

Then /^mongrel status should be good$/ do
  @servers.each_with_index do |server,i|
    response = server.spot_check_command?("service mongrel_cluster status")
    raise "Mongrel status failed" unless response
  end
end

When /^I force log rotation$/ do
  @frontends.each_with_index do |server,i|
    response = server.spot_check_command?('logrotate -f /etc/logrotate.conf')
    raise "Logrotate restart failed" unless response
  end
end

Then /^I should see "([^\"]*)"$/ do |logfile|
  @frontends.each_with_index do |server,i|
    response = server.spot_check_command?('test -f #{logfile}')
    raise "Log file does not exist" unless response
  end
end

Then /^the lb tests should succeed$/ do
  steps %Q{
    Given A deployment with frontends
    When I cross connect the frontends
    Then the cross connect script completes successfully
    And I should see all servers in the haproxy config
#    And I should see all servers being served from haproxy
  }
end
