#
# Cookbook Name:: remote_recipe
# Recipe:: do_tag_test
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

# add tag
right_link_tag "test:foo=bar"


# todo: verify tag exists


# remove tag
right_link_tag "test:foo=bar" do
  action :remove
end


# todo: verify tag is gone
