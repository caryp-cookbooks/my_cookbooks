#
# Cookbook Name:: ohai_test
# Recipe:: default
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'ohai_test::do_write_to_file'
include_recipe 'ohai_test::do_test_values'