require 'rubygems'
require 'trollop'
require 'rest_connection'
require File.dirname(__FILE__) + '/lib/deployment_monk'
require 'ruby-debug'

dm = DeploymentMonk.new([46536,46536])
dm.generate_variations
debugger
puts 'blah'
