#
# Cookbook Name:: rightlink_test
# Recipe:: persist_test_setup
#
# Copyright 2010, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

# Create this resource, but don't do anything yet
# Just persist for persist_test_check to use within an operational script
template "persist_test" do
  path node.persist_test.path
  source "persist_test.erb"
  action :nothing
end

