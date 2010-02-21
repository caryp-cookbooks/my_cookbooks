#!/usr/bin/env ruby

require "rubygems"
require "rest_connection"
require "net/ssh"
require "#{File.dirname(__FILE__)}/run_test.rb"
require "json"
require "/var/spool/ec2/meta-data-cache.rb"

@test_params = JSON.parse File.read("#{File.dirname(__FILE__)}/static.json")

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
@cuke_tags = @test_params["cuke_tags"]
@instance_types =  @test_params["clouds"]["ec2"]["instance_types"]
@children = Array.new

@test_params["clouds"]["ec2"]["regions"].each do |region,params|
  puts params["ssh_key"].inspect
  ssh_key = params["ssh_key"]
  security_group = params["security_group"]
  cloud_id = params["cloud_id"]

puts "ssh_key = "+ssh_key
puts "security_group = " + security_group
puts "cloud_id = " + cloud_id

  params["images"].each do |image|
    image_href = image["href"]
    arch = image["arch"]
    instance_types = @instance_types[arch]

    deployment_name = "virtual_monkey-#{rand(999999999) + 1000000000 }"


    puts "forking process"
    #@children << Process.fork {
      puts "run test with #{image["name"]}"
      run_test( deployment_name, @deployment_inputs, @front_end_template, @app_server_template, image_href, ssh_key, security_group, cloud_id, instance_types, @cuke_tags )
      puts "finished running tests"
      puts result[1]
      if result[0].success? 
        puts "tests passed"
      else
        puts "tests failed"
      end
    #}
  end
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




