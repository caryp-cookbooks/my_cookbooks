require "rubygems"
require "rest_connection"
require "net/ssh"

Given /A deployment named "(.*)"/ do | deployment |
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

Then /I should successfully run a recipe named "(.*)"/ do |recipe|
  @server.run_recipe(recipe)
end 

