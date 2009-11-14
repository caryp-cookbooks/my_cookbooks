#
# Cookbook Name:: storage_test
# Recipe:: default
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

remote_object_store "resource_one" do
  user "blah"
  key "blah"
  provider_type @node[:remote_object_store][:provider_type] 
  action :nothing
end

remote_object_store "resource_one" do
  container "MyBucket"
  object_name "file1.txt"
  action :get
end

remote_object_store "resource_one" do
  object_name "file2.txt"
  action :get
end

