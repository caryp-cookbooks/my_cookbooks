#
# Cookbook Name:: resat
# Recipe:: default
#
# Copyright 2010, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
base_dir = node[:resat][:base_dir]

# Install packages for RESAT
package "ruby1.8-dev" 
package "rdoc" 
package "libmysql-ruby"

# Install gem dependencies
[ "ruby-debug", "kwalify", "cucumber", "net-ssh" ].each { |p| gem_package p }


# Install RESAT
# gem sources -a https://gemcutter.org
gem_package "resat"

# Install attached rest_connection gem (TODO: publish to gemcutter)
remote_file "/tmp/rest_connection-0.0.1.gem" do 
  source "rest_connection-0.0.1.gem"
end
gem_package "/tmp/rest_connection-0.0.1.gem" do
  version "0.0.1"
end

# Configure rest_connection
directory "#{node[:resat][:base_dir]}/.rest_connection"

template "#{node[:resat][:base_dir]}/.rest_connection/rest_api_config.yaml" do
  source "rest_api_config.yaml.erb"
  mode "600"
end

# Install test repo
repo_git_pull "Get test repo" do
  url "git@github.com:caryp/my_cookbooks.git"
  user git
  dest "#{base_dir}/tests"
  branch "db_mysql"
  cred node[:resat][:git_key]
end

# Create dummy output and input files for RESAT
file "#{base_dir}/variables.txt"
file "#{base_dir}/variables1.txt"

