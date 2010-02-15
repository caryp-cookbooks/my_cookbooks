#
# Cookbook Name:: remote_recipe
# Recipe:: ping
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

# touch file
template "/tmp/ping.log" do
  source "pingpong.erb"
  variables ( 
    :ping_type => "PING", 
    :from => @node[:remote_recipe][:from],
    :tags => @node[:remote_recipe][:tags] )
  action :create
end

# send pong to sender
remote_recipe "pong sender" do
  recipe "rightlink_test::resource_remote_recipe_pong"
  recipients @node[:remote_recipe][:from]
end
