#
# Cookbook Name:: lwrp_demo
# Recipe:: do_source_pull
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

Chef::Log.info("...do some stuff here...")

repo "get source code" do
  destination @node[:lwrp_demo][:destination]
  action :pull
  provider @node[:lwrp_demo][:provider]
end

Chef::Log.info("...do some other stuff here...")

bash "show repo contents" do
  code "echo `ls #{@node[:lwrp_demo][:destination]}`"
end