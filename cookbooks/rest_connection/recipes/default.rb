#
# Cookbook Name:: rest_connection
# Recipe:: default
#
# Copyright 2010, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

["libxml2-dev", "libxml-ruby1.8", "libxslt1-dev"].each { |p| package p }

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