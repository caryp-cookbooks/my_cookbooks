require 'rubygems'
require 'rest_connection'
require File.dirname(__FILE__) + '/lib/deployment_monk'
require 'ruby-debug'

dm = DeploymentMonk.new([51712,51712])
dm.generate_variations
debugger
puts 'blah'
