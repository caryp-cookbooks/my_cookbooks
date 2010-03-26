require 'rubygems'
require 'rest_connection'
require 'ruby-debug'

#TODO get rid of the @servers, @frontends, @appservers and just use the server_set hash.
Given /^A deployment$/ do
  @server_set = Hash.new
  raise "FATAL:  Please set the environment variable $DEPLOYMENT" unless ENV['DEPLOYMENT']
  @deployment = Deployment.find_by_nickname_speed(ENV['DEPLOYMENT']).first
  raise "FATAL: Couldn't find a deployment with the name #{ENV['DEPLOYMENT']}!" unless @deployment
#  @servers = @deployment.servers_no_reload
  @server_set["all"] = @deployment.servers_no_reload
  raise "FATAL: Deployment #{ENV['DEPLOYMENT']} does not contain any servers!" unless @server_set["all"]
  raise "need at 4 servers to start, only have: #{@server_set["all"].size}" unless @server_set["all"].size == 4
  @server_set["all"].each { |s| s.settings }
  puts "found deployment to use: #{@deployment.nickname}, #{@deployment.href}"
end

When /^I launch the "([^\"]*)" servers$/ do |server_set|
  puts "entering :I launch the #{server_set}"
  @server_set[server_set] = @server_set["all"].select { |s| s.nickname =~ /#{server_set}?/ }
  raise "need at least 2 #{server_set} servers to start, only have: #{@server_set[server_set].size}" unless @server_set[server_set].size == 2
  @server_set[server_set].each { |s| s.start }
  puts "exiting :I launch the #{server_set}"
end

#When /^I launch the frontends$/ do
#  puts "entering :I launch the frontends"
#  @frontends = @servers.select { |s| s.nickname =~ /frontend?/ }
#  @server_set["frontend"] = @frontends
#  raise "need at least 2 frontends to start, only have: #{@frontends.size}" unless @frontends.size == 2
#  @frontends.each { |s| s.start }
#  puts "exiting :I launch the frontends"
#end

#When /^I launch the appservers$/ do
#  puts "entering :I launch the appservers"
#  @appservers = @servers.select { |s| s.nickname =~ /appserver?/ }
#  @server_set["app"] = @appservers
#  raise "need at least 2 appservers to start, only have: #{@appservers.size}" unless @appservers.size == 2
#  @appservers.each { |s| s.start }
#  puts "exiting :I launch the appservers"
#end

Then /^the "([^\"]*)" servers become non\-operational$/ do |server_set|
#Then /^the frontends become non\-operational$/ do
  @server_set[server_set].each { |s| s.wait_for_state('decommissioning') }
end

#Then /^the appservers become non\-operational$/ do
#  @server_set["app"].each { |s| s.wait_for_state('decommissioning') }
#end

Then /^the "([^\"]*)" servers become operational$/ do |server_set|
  puts "entering :the #{server_set} servers become operational"
  @server_set[server_set].each { |s| s.wait_for_operational_with_dns ; s.settings ; s.reload }
  puts "exiting :the #{server_set} servers become operational"
end

#Then /^the frontends become operational$/ do
#  puts "entering :the frontends become operational"
#  @server_set["frontend"].each { |s| s.wait_for_operational_with_dns ; s.settings ; s.reload }
#  puts "exiting :the frontends become operational"
#end

#Then /^the appservers become operational$/ do
#  puts "entering :the appservers become operational"
#  @server_set["app"].each { |s| s.wait_for_operational_with_dns ; s.settings ; s.reload }
#  puts "exiting :the appservers become operational"
#end

Given /^with a known OS$/ do
  @servers_os = Array.new
  @server_set["all"].each do |server|
    puts "server.spot_check_command?(\"lsb_release -is | grep Ubuntu\") = #{server.spot_check_command?("lsb_release -is | grep Ubuntu")}"
    if server.spot_check_command?("lsb_release -is | grep Ubuntu")
      puts "setting server to ubuntu"
      @servers_os << "ubuntu"
    else
      puts "setting server to centos"
      @servers_os << "centos"
    end
  end
end

When /^I query "([^\"]*)" on all "([^\"]*)" servers on port "([^\"]*)"$/ do |uri, server_set, port|
#When /I query "([^\"]*)" on "([^\"]*)" servers on port "([^\"]*)"$/ do |uri, server_set, port|
  @responses = Array.new
  @server_set[server_set].each { |s| 
    cmd = "curl -s #{s['dns-name']}:#{port}#{uri} 2> /dev/null "
    puts cmd
    @responses << `#{cmd}` 
  }
end

#When /^I query "([^\"]*)" on all servers$/ do |uri|
#  @responses = Array.new
#  @servers.each { |s| 
#    #puts "s.inspect = #{s.inspect}"
#    cmd = "curl -s #{s['dns-name']}:8000#{uri} 2> /dev/null "
#    puts cmd
#    @responses << `#{cmd}` 
#  }
#end

# Can we also pass in the array to use?  frontends vs servers vs appservers?  Then this can be one step
#Then /^I query "([^\"]*)" on all frontend servers$/ do |uri|
#  @responses = Array.new
#  @frontends.each { |s| 
#    cmd = "curl -s #{s['dns-name']}:8000#{uri} 2> /dev/null "
#    puts cmd
##    @responses << `#{cmd}` 
#  }
#end

Then /^I should see "([^\"]*)" in all the responses$/ do |message|
  @responses.each { |r| puts "r  #{r}" ; r.should include(message) }
end

When /^I reboot the "([^\"]*)" servers$/ do |server_set|
  puts "entering :I reboot the #{server_set} servers"
  @server_set[server_set].each { |s| s.reboot }
  puts "exiting :I reboot the #{server_set} servers"
end

#When /^I reboot the appservers$/ do
#  puts "entering: I reboot the appservers"
#  @server_set["app"].each { |s| s.reboot }
#  puts "exiting :I reboot the appservers"
#end

Given /^an operational app deployment$/ do
  steps %Q{
    Given A deployment
    When I launch the frontends
    Then the frontends become operational
    When I launch the appservers
    Then the appservers become operational
  }

end

When /^I reboot the app deployment$/ do
  steps %Q{
    Given A deployment
    When I launch the frontends
    And I launch the appservers
    And I reboot the "frontend" servers
    Then the frontends become non-operational
    Then the frontends become operational
    When I reboot the "app" servers
    Then the appservers become non-operational
    Then the appservers become operational
  }
end

Then /^the app tests should succeed$/ do
    Given 'A deployment'
    When 'I query "/index.html" on all servers'
    Then 'I should see "html serving succeeded." in all the responses'
    When 'I query "/appserver/" on all servers'
    Then 'I should see "configuration=succeeded" in all the responses'
    When 'I query "/dbread/" on all servers'
    Then 'I should see "I am in the db" in all the responses'
    When 'I query "/serverid/" on all servers'
    Then 'I should see "hostname=" in all the responses'
    When 'I query "/dbread/" on all servers'
    Then 'I should see "I am in the db" in all the responses'
end

