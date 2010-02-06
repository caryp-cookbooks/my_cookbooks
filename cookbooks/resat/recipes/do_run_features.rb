#
# Cookbook Name:: resat
# Recipe:: default
#
# Copyright 2010, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
test_dir = "node[:resat][:base_dir]/tests"

gem_package "rest_connection"

repo_git_pull "Get cucumber feature tests" do
  url "git@github.com:caryp/my_cookbooks.git"
  user git
  dest test_dir
  cred node[:resat][:git_key]
end

execute "cucumber --tags #{node[:cucumber][:tags]}" do
  cwd test_dir
end

