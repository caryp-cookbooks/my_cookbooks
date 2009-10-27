#
# Cookbook Name:: core_env
# Recipe:: do_write_to_file
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

template "/tmp/ohai_values.log" do
  source "ohai_values.erb"
  action :create
end

raise "ERROR: ohai ruby_bin value: #{@node[:languages][:ruby][:ruby_bin]} != '/usr/bin/ruby1.8'" unless @node[:languages][:ruby][:ruby_bin] == '/usr/bin/ruby1.8'
raise "ERROR: ohai gems_dir value: #{@node[:languages][:ruby][:gems_dir]} != '/usr/lib/ruby/gems/1.8'" unless @node[:languages][:ruby][:gems_dir] == '/usr/lib/ruby/gems/1.8'
