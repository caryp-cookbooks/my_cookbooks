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
  url "github.com:rightscale/right_test.git"
  user git
  dest base_dir
  cred node[:resat][:git_key]
end

# Create dummy output and input files for RESAT
file "#{base_dir}/variables.txt"
file "#{base_dir}/variables1.txt"

