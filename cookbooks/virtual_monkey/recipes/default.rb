#
# Cookbook Name:: virtual_monkey
# Recipe:: default
#
# Copyright 2010, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
include_recipe "virtual_monkey::setup_apptest_database"

["postfix", "mutt", "mailutils"].each { |p| package p }

# grab application source from remote repository
repo_git_pull "Get Test Repository" do
  url @node[:virtual_monkey][:code][:url]
  branch @node[:virtual_monkey][:code][:branch] 
  dest "/root/test"
  cred @node[:virtual_monkey][:code][:credentials]
end