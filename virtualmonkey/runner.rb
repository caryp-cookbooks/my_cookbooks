#!/usr/bin/env ruby

require "rubygems"
require "rest_connection"
require "net/ssh"
require "#{File.dirname(__FILE__)}/run_test.rb"
require "json"
require "/var/spool/ec2/meta-data-cache.rb"


raise "please pass in a json file to load" unless ARGV[0]

puts "using #{ARGV[0]} for inputs..."


## parse out config file
@test_params = JSON.parse File.read(File.join(File.dirname(__FILE__),ARGV[0]))
@deployment_inputs = @test_params["inputs"]
@deployment_inputs["MASTER_DB_DNSNAME"] = "text:#{ENV['EC2_PUBLIC_HOSTNAME']}"
@front_end_template =  @test_params["front_end_template"]
@app_server_template =  @test_params["app_server_template"]
@connect_script = @test_params["connect_script"]
@cuke_tags = @test_params["cuke_tags"]
@instance_types =  @test_params["clouds"]["ec2"]["instance_types"]
@children = Array.new
@results = Array.new
@good_results = Array.new
@bad_results = Array.new
@@test = Array.new

## iterate over ec2 regions
@test_params["clouds"]["ec2"]["regions"].each do |region,params|
  ssh_key = params["ssh_key"]
  security_group = params["security_group"]
  cloud_id = params["cloud_id"]
  server_inputs = @deployment_inputs
  server_inputs = @deployment_inputs.merge(params["inputs"]) if params["inputs"]
  private_key_path = params["private_key_path"]


  ## iterate over images
  params["images"].each do |image|
    image_href = image["href"]
    arch = image["arch"]
    instance_types = @instance_types[arch]
    deployment_name = "virtual_monkey-#{region}-#{image["name"]}-#{rand(999999999) + 1000000000 }"
  
    puts "forking process"
    @children << Thread.fork {
      puts "run test with #{image["name"]}"
      result = run_test( deployment_name, server_inputs, @front_end_template, @app_server_template,@connect_script, image_href, ssh_key, security_group, cloud_id, instance_types, private_key_path, @cuke_tags)
      @results << result
      puts "finished running tests"
      puts result[1]
      if result[0].success? 
        puts "tests passed"
        @good_results << result
      else
        puts "tests failed"
        @bad_results << result
      end
      @@test << "foo"
      puts "@@TEST = #{@@test}"
      puts "@@test.size = #{@@test.size}"
    }
  end
end

puts "waiting for children"

Signal.trap("SIGINT") do
  puts "Caught CTRL-C, killing children.."
  @children.each {|c| Process.kill("INT", c)}
  sleep 1
  @children.each {|c| Process.kill("INT", c)}
end

#@children.each {|c| Process.wait2(c)}

## create report 
git_log = `git log -3`
report = <<EOF
  Ran #{@results.size} tests
  
  #{@bad_results.size} failures
  #{@good_results.size} successes

  I am running on :
  git_log

@@test.size = #{@@test.size}
      puts "@@TEST = "+@@test
EOF

puts report

puts "run finished" 




