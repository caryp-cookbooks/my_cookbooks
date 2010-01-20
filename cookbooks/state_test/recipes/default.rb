#
# Cookbook Name:: state_test
# Recipe:: default
#
# Copyright 2010, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

ruby_block "set value" do
  block do
    node[:state_test][:value] = "recipe"
  end
end
     
    
