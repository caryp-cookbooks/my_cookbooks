#
# Cookbook Name:: core_env
# Recipe:: do_test_values
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

test_failed = ( @node[:languages][:ruby][:ruby_bin] =~ /sandbox/ )
raise "ERROR: ohai ruby plugin: 'ruby_bin' value points to sandbox: #{@node[:languages][:ruby][:ruby_bin]}" if test_failed

test_failed = ( @node[:languages][:ruby][:gems_dir] =~ /sandbox/ )
raise "ERROR: ohai ruby plugin: 'gems_dir' value points to sandbox: #{@node[:languages][:ruby][:gems_dir]}" if test_failed
