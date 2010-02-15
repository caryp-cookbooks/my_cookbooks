#
# Cookbook Name:: remote_recipe
# Recipe:: ping
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

# touch file
template "/tmp/pong.log" do
  backup 100
  source "pingpong.erb"
  variables ( 
    :ping_type => "PONG", 
    :from => @node[:remote_recipe][:from],
    :tags => @node[:remote_recipe][:tags] )
  action :create
end


