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
gem_package "ruby-debug"
gem_package "kwalify"

# Install RESAT
# gem sources -a https://gemcutter.org
gem_package "resat"

# Install RESAT configuration and scenario files
repo_git_pull "Get right_test" do
  url "git@github.com:rightscale/right_test.git"
  user git
  dest "#{base_dir}/right_test"
  cred node[:resat][:git_key]
end

# Install attached rest_connection gem (TODO: publish to gemcutter)
remote_file "/tmp/rest_connection-0.0.1.gem" do 
  source "rest_connection-0.0.1.gem"
end
gem_package "rest_connection-0.0.1.gem"  

# Create dummy output and input files for RESAT
file "#{base_dir}/variables.txt"
file "#{base_dir}/variables1.txt"

