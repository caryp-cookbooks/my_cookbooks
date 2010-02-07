#
# Cookbook Name:: resat
# Recipe:: default
#
# Copyright 2010, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
test_dir = "#{node[:resat][:base_dir]}/tests"

[ "rest_connection", "cucumber", "net-ssh" ].each { |gem| gem_package gem }

directory "#{[:resat][:base_dir]}/.rest_connection"

template "#{[:resat][:base_dir]}/.rest_connection/rest_api.config.yaml" do
  source "rest_api_config.yaml.erb"
  mode "600"
end

repo_git_pull "Get cucumber feature tests" do
  url "git@github.com:caryp/my_cookbooks.git"
  user git
  dest test_dir
  branch "db_mysql"
  cred node[:resat][:git_key]
end

execute "cucumber --tags #{node[:cucumber][:tags]}" do
  cwd test_dir
end

