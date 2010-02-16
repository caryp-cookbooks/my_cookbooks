#
# Cookbook Name:: remote_recipe
# Recipe:: do_tag_test
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
COLLECTION_NAME = "tag_test"
TAG = "test:foo="

# Add tag
right_link_tag "#{TAG}bar"

# Verify tag exists
server_collection COLLECTION_NAME do
  tags [ TAG ]
end

ruby_block "tags exists?" do
  block do
    Chef::Log.info "Displaying Tags..."
    h = node[:server_collection][COLLECTION_NAME]
    tags = h[h.keys[0]]
    result = tags.select { |s| s =~ /#{TAG}/ }
    raise "ERROR: right_link_tag resource failed to add tag." if result.empty?
  end
end

# Remove tag
right_link_tag "test:foo=bar" do
  action :remove
end

# Verify tag is gone
server_collection COLLECTION_NAME do
  tags [ TAG ]
end
  
ruby_block "tags gone?" do
  block do
    Chef::Log.info "Displaying Tags..."
    h = node[:server_collection][COLLECTION_NAME]
    tags = h[h.keys[0]]
    result = tags.select { |s| s =~ /#{TAG}/ }
    raise "ERROR: right_link_tag resource failed to remove a tag." unless result.empty?
  end
end
