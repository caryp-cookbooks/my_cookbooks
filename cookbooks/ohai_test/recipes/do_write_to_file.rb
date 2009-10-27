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