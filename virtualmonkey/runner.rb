#!/usr/bin/env ruby

require "rubygems"
require "rest_connection"
require "net/ssh"
require "#{File.dirname(__FILE__)}/run_test.rb"
require "json"
require "/var/spool/ec2/meta-data-cache.rb"

@test_params = JSON.parse File.read("#{ENV['DIR']}/static.json")

puts 
puts "test_name = #{@test_params["test_name"]}"
puts 
puts "tags = #{@test_params["tags"]}"
puts 
puts "front_end_template = #{@test_params["front_end_template"]}"
puts "app_server_template = #{@test_params["app_server_template"]}"



@deployment_inputs = @test_params["inputs"]
@deployment_inputs["MASTER_DB_DNSNAME"] = "text:#{ENV['EC2_PUBLIC_HOSTNAME']}"
@front_end_template =  @test_params["front_end_template"]
@app_server_template =  @test_params["app_server_template"]
@ssh_key = @test_params["clouds"]["ec2"]["regions"]["us-east"]["ssh_key"]
@security_group = @test_params["clouds"]["ec2"]["regions"]["us-east"]["security_group"]
@cloud = "1"
@cuke_tags = @test_params["cuke_tags"]
@children = Array.new

@test_params["clouds"]["ec2"]["regions"]["us-east"]["images"].each do |image|
  deployment_name = "virtual_monkey-#{rand(999999999) + 1000000000 }"
  puts "forking process"
  @children << Process.fork {
    image_href = image["href"]
    arch = image["arch"]
    instance_types =  @test_params["clouds"]["ec2"]["instance_types"][arch]
    puts "run test with #{image["name"]}"
    result = run_test( deployment_name, @deployment_inputs, @front_end_template, @app_server_template, image_href, @ssh_key, @security_group, @cloud, instance_types, @cuke_tags )
    puts "finished running tests"
    puts result[1]
    if result[0].success? 
      puts "tests passed"
    else
      puts "tests failed"
    end
  }
  
end

puts "waiting for children"

Signal.trap("SIGINT") do
  puts "Caught CTRL-C, killing children.."
  @children.each {|c| Process.kill("INT", c)}
  sleep 1
  @children.each {|c| Process.kill("INT", c)}
end

@children.each {|c| Process.wait2(c)}

puts "run finished" 




