require "rubygems"
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
  script_to_run = st.executables.detect { |ex| ex.name =~  /LB app to HA proxy connect/i }
  @frontends.each { |s| @statuses << s.run_script(script_to_run) }
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
    @app_server_ips.each { |ip| haproxy_config.to_s.should include(ip) }
  end
 
  puts "Exiting from :I should see all servers in the haproxy config"

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

Then /^the lb tests should succeed$/ do
  steps %Q{
    Given A deployment with frontends
    When I cross connect the frontends
    Then the cross connect script completes successfully
    And I should see all servers in the haproxy config
    And I should see all servers being served from haproxy
  }
end
