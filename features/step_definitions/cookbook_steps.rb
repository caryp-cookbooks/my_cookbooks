require "rubygems"
require "rest_connection"
require "net/ssh"


Given /A deployment named "(.*)"/ do | deployment |
  @all_servers = Array.new
  @all_responses = Array.new
  @deployment = Deployment.find_by_nickname_speed(deployment).first
  raise "FATAL: Couldn't find a deployment with the name #{deployment}!" unless deployment
end

Given /A server named "(.*)"/ do |server|
  servers = @deployment.servers_no_reload
  @server = servers.detect { |s| s.nickname =~ /#{server}/ }
  @server.start
  @server.wait_for_state("operational")
  raise "FATAL: couldn't find a server named #{server}" unless server
end

Given /^"([^\"]*)" operational servers named "([^\"]*)"$/ do |num, server_name|
  servers = @deployment.servers_no_reload
  @servers = servers.select { |s| s.nickname =~ /#{server_name}/ }
  @servers.each do |s| 
    @all_servers.push s
  end
  #@all_servers.push  { |s| s.nickname =~ /#{server_name}/ }
  raise "need at least #{num} servers to start, only have: #{@servers.size}" if @servers.size < num.to_i
  @servers.each { |s| s.start } 
  @servers.each { |s| s.wait_for_operational_with_dns } 
end

Given /An ssh key located at "(.*)"/ do |ssh_key|
  @ssh_key_path = ssh_key
end

Then /I should successfully run a recipe named "(.*)"/ do |recipe|
  @server.run_recipe(recipe)
end 

Then /^I should run a recipe named "([^\"]*)" on server "([^\"]*)"\.$/ do |recipe, server_index|
  human_index = server_index.to_i - 1
  @servers[human_index].run_recipe(recipe)
end 

When /^I run a recipe named "([^\"]*)" on server "([^\"]*)"\.$/ do |recipe, server_index|
  human_index = server_index.to_i - 1
  STDOUT.puts "#{recipe} -> root@#{@servers[human_index].dns_name}"
  @response = @servers[human_index].run_recipe(recipe) unless @ssh_key_path
  @response = @servers[human_index].run_recipe(recipe, @ssh_key_path) if @ssh_key_path # hackey hack hack
end 

Then /^I should sleep (\d+) seconds\.$/ do |seconds|
  sleep seconds.to_i
end

Then /^I should run a command "([^\"]*)" on server "([^\"]*)"\.$/ do |command, server_index|
  human_index = server_index.to_i - 1
  @servers[human_index].spot_check(command) { |result| puts result }
end

Then /^I should run a mysql query "([^\"]*)" on server "([^\"]*)"\.$/ do |query, server_index|
  human_index = server_index.to_i - 1
  query_command = "echo -e '#{query}'|mysql"
  @servers[human_index].spot_check(query_command) { |result| puts result }
end

Given /^An "([^\"]*)" for an operational app server$/ do |arg1|
  puts "entering op server with value #{arg1}"
  @endpoint = arg1
end

When /^I query "([^\"]*)"$/ do |uri|
  uri = uri + '/' unless uri.nil? 
  #puts "about to do: curl -s #{@endpoint}#{url}"
  @response = `curl -s #{@endpoint}#{uri}` 
end


When /^I query "([^\"]*)" on all servers$/ do |uri|
  uri = uri + '/' unless uri.nil?
  @all_servers.each_with_index do |s,i|
    @all_responses[i] = `curl -s #{s['dns-name']}:8000#{uri}`
  end
end

Then /^I should see "([^\"]*)" in the response$/ do |message|
  #puts "looking for #{message} in #{@response}"
  @response.should include(message)
end

Then /^I should see "([^\"]*)" in all the responses$/ do |message|
  @all_servers.each_with_index do |s,i|
    @all_responses[i].should include(message)
  end
end

Then /^I should not see "([^\"]*)" in the response$/ do |message|
  @response.should_not include(message) 
end

Then /^I should not see "([^\"]*)" in all the responses$/ do |message|
  @all_servers.each_with_index { |s,i| @all_responses[i].should_not include(message) }
end

When /^I run "([^\"]*)"$/ do |command|
  @response = @server.spot_check_command?(command)
end

Then /^it should exit successfully$/ do
  @response.should be true
end

Then /^it should converge successfully\.$/ do
  @response[:status].should == true
end

When /^I run "([^\"]*)" on all servers$/ do |command|
  @all_servers.each_with_index do |s,i|
    @all_responses[i] = s.spot_check_command?(command)
  end
end

Then /^it should exit successfully on all servers$/ do
  @all_responses.each do |response|
    response.should be true
  end
end

Then /^it should not exit successfully on any server$/ do
  @all_responses.each do |response|
    response.should_not be true
  end
end
