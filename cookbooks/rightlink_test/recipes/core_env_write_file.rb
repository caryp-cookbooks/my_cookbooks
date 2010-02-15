#
# Cookbook Name:: core_env
# Recipe:: do_write_to_file
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

template "/tmp/core_env.log" do
  source "core_env.erb"
  action :create
end