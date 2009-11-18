#
# Cookbook Name:: backup_test
# Recipe:: default
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
include_recipe "backup_test::test_s3"
include_recipe "backup_test::test_cloudfiles"