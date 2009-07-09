#
# Cookbook Name:: repo_git
# Recipe:: pull
#
# Copyright 2009, RightScale, Inc.
#
include_recipe "repo_git"

repo_git_pull "Get Repository" do
  url @node[:repo_git][:url] 
  branch @node[:repo_git][:branch]
  user @node[:repo_git][:user]
  dest @node[:repo_git][:dest]
  cred @node[:repo_git][:cred]
end

