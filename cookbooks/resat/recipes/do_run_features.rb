#
# Cookbook Name:: resat
# Recipe:: default
#
# Copyright 2010, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
base_dir = node[:resat][:base_dir]

gem_package "rest_connection"

repo_git_pull "Get cucumber feature tests" do
  url "git@github.com:caryp/my_cookbooks.git"
  user git
  dest "#{base_dir}/tests"
  cred node[:resat][:git_key]
end



