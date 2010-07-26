#
# Cookbook Name:: rightlink_test
# Recipe:: persist_test_check
#
# Copyright 2010, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

# This should be run as an operational script
# make sure you have rightlink_test::persist_test_setup in your boot scripts list

# Call the create action on a resourse persisted to disk in the boot scripts 
template "persist_test" do
  action :create
end

output_file node.persist_test.path