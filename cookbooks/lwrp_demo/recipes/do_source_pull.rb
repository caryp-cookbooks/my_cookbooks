#
# Cookbook Name:: lwrp_demo
# Recipe:: do_source_pull
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

Chef::Log.info("do some stuff here")

repo "get source code" do
  destination "/tmp/demo"
  action :pull
  
  provider "repo_git"
end

Chef::Log.info("do some other stuff here")