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

Given /(\d+) operational servers named "(.*)"/ do |num, server|
  servers = @deployment.servers_no_reload
  @servers = servers.select { |s| s.nickname =~ /#{server}/ }
  raise "need at least #{num} servers to start, only have: #{@servers.size}" if @servers.size < num.to_i
  @servers.each { |s| s.start } 
  @servers.each { |s| s.wait_for_operational_with_dns } 
end

Then /I should successfully run a recipe named "(.*)"/ do |recipe|
  @server.run_recipe(recipe)
end 

Then /I should successfully run a recipe named "(.*)" on server (\d+)/ do |recipe, server_index|
  @servers[server_index].run_recipe(recipe)
end 

