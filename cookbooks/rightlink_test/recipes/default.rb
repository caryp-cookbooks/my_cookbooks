#
# Cookbook Name:: rightlink_test
# Recipe:: default
#
# Copyright 2010, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
include_recipe "rightlink_test::core_env_write_file"
include_recipe "rightlink_test::ohai_write_file"
include_recipe "rightlink_test::ohai_test_values"
include_recipe "rightlink_test::resource_remote_recipe_setup" # run remote_recipe_test as an op script
include_recipe "rightlink_test::resource_right_link_tag_test"
include_recipe "rightlink_test::resource_server_collection_setup"
include_recipe "rightlink_test::resource_server_collection_test"
include_recipe "rightlink_test::tag_break_point_test" # add test_should_never_run as last boot script
include_recipe "rightlink_test::tag_cookbook_path_test"
