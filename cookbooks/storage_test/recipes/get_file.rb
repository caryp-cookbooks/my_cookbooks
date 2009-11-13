#
# Cookbook Name:: storage_test
# Recipe:: default
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

remote_object_store "get a file" do
  user "blah"
  key "blah"
  action :get
end