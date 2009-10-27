#
# Cookbook Name:: core_env
# Recipe:: do_test_values
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

test_pass = (@node[:languages][:ruby][:ruby_bin] == '/usr/bin/ruby1.8')
raise "ERROR: ohai ruby_bin value: #{@node[:languages][:ruby][:ruby_bin]} != '/usr/bin/ruby1.8'" unless test_pass

test_pass = (@node[:languages][:ruby][:gems_dir] == '/usr/lib/ruby/gems/1.8')
raise "ERROR: ohai gems_dir value: #{@node[:languages][:ruby][:gems_dir]} != '/usr/lib/ruby/gems/1.8'" unless test_pass
