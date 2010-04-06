#
# Cookbook Name:: lwrp_demo
# Recipe:: do_source_pull
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

Chef::Log.info("...do some stuff here...")

repo "default" do
  destination @node[:lwrp_demo][:destination]
  action :pull
end

Chef::Log.info("...do some other stuff here...")

