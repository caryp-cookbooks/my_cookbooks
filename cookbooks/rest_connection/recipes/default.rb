#
# Cookbook Name:: rest_connection
# Recipe:: default
#
# Copyright 2010, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

["libxml2-dev", "libxml-ruby1.8", "libxslt1-dev"].each { |p| package p }

gem_package "activesupport" do
  version "2.3.5" 
end

gem_package "gemcutter" do
  version "0.5.0" 
end

["jeweler", "rdoc", "right_aws", " sqlite3-ruby",  "sqlite3-dev", "ruby-debug"].each { |p| gem_package p }

ssh_keys = Array.new
node[:rest_connection][:ssh][:key].values do |kval|
  ssh_keys << "- #{kval}"
end

# Configure rest_connection
directory "#{node[:test][:path][:src]}/.rest_connection"

template "#{node[:test][:path][:src]}/.rest_connection/rest_api_config.yaml" do
  source "rest_api_config.yaml.erb"
  mode "600"
  variables({ :keys => ssh_keys })
end