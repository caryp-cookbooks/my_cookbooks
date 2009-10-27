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

ruby_block "Output Values" do
  block do
    ::File.open("/tmp/ohai_values.log") do |infile| 
      while (line = infile.gets) 
        Chef::Log.info(line) 
      end 
    end
  end
end

