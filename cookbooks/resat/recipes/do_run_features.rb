#
# Cookbook Name:: resat
# Recipe:: default
#
# Copyright 2010, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

execute "cucumber --tags @#{node[:resat][:test][:type]}" do
  cwd "#{node[:resat][:base_dir]}/tests"
  user "root"
end

