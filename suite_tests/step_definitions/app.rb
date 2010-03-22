require 'rubygems'
require 'rest_connection'

Given /^A deployment$/ do
  raise "FATAL:  Please set the environment variable $DEPLOYMENT" unless ENV['DEPLOYMENT']
  @deployment = Deployment.find_by_nickname_speed(ENV['DEPLOYMENT']).first
  raise "FATAL: Couldn't find a deployment with the name #{ENV['DEPLOYMENT']}!" unless @deployment
  @servers = @deployment.servers_no_reload
  raise "FATAL: Deployment #{ENV['DEPLOYMENT']} does not contain any servers!" unless @servers
  raise "need at 4 servers to start, only have: #{@servers.size}" unless @servers.size == 4
  @servers.each { |s| s.settings }
  puts "found deployment to use: #{@deployment.nickname}, #{@deployment.href}"
end

When /^I launch the frontends$/ do
  puts "entering :I launch the frontends"
  @frontends = @servers.select { |s| s.nickname =~ /frontend?/ }
  raise "need at least 2 frontends to start, only have: #{@frontends.size}" unless @frontends.size == 2
  @frontends.each { |s| s.start }
  puts "exiting :I launch the frontends"
end

When /^I launch the appservers$/ do
  puts "entering :I launch the appservers"
  @appservers = @servers.select { |s| s.nickname =~ /appserver?/ }
  raise "need at least 2 appservers to start, only have: #{@appservers.size}" unless @appservers.size == 2
  @appservers.each { |s| s.start }
  puts "exiting :I launch the appservers"
end

Then /^the frontends become non\-operational$/ do
  @frontends.each { |s| s.wait_for_state('decommissioning') }
end

Then /^the appservers become non\-operational$/ do
  @appservers.each { |s| s.wait_for_state('decommissioning') }
end

Then /^the frontends become operational$/ do
  puts "entering :the frontends become operational"
  @frontends.each { |s| s.wait_for_operational_with_dns ; s.settings ; s.reload }
  puts "exiting :the frontends become operational"
end

Then /^the appservers become operational$/ do
  puts "entering :the appservers become operational"
  @appservers.each { |s| s.wait_for_operational_with_dns ; s.settings ; s.reload }
  puts "exiting :the appservers become operational"
end

Given /^with a known OS$/ do
  @servers_os = Array.new
  @servers.each do |server|
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

When /^I query "([^\"]*)" on all servers$/ do |uri|
  @responses = Array.new
  @servers.each { |s| 
    #puts "s.inspect = #{s.inspect}"
    cmd = "curl -s #{s['dns-name']}:8000#{uri} 2> /dev/null "
    puts cmd
    @responses << `#{cmd}` 
  }
end

Then /^I should see "([^\"]*)" in all the responses$/ do |message|
  @responses.each { |r| puts "r  #{r}" ; r.should include(message) }
end

When /^I reboot the frontends$/ do
  puts "entering :I reboot the frontends"
  @frontends.each { |s| s.reboot }
  puts "exiting :I reboot the frontends"
end

When /^I reboot the appservers$/ do
  puts "entering: I reboot the appservers"
  @appservers.each { |s| s.reboot }
  puts "exiting :I reboot the appservers"
end

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
    And I reboot the frontends
    Then the frontends become non-operational
    Then the frontends become operational
    When I reboot the appservers
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
