#
# Cookbook Name:: lwrp_demo
# Recipe:: do_source_pull
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

ruby_block "...do some stuff here..." do
  block do end
end

repo "default" do
  destination @node[:lwrp_demo][:destination]
  action :pull
end

ruby_block "...do some other stuff here..." do
  block do end
end
#Chef::Log.info("...do some other stuff here...")

