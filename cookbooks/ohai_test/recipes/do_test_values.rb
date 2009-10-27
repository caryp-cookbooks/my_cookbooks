#
# Cookbook Name:: core_env
# Recipe:: do_test_values
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

ruby_block "ruby_bin should not point to sandbox" do
  block do
    test_failed = ( @node[:languages][:ruby][:ruby_bin] =~ /sandbox/ )
    raise "ERROR: ohai ruby plugin: 'ruby_bin' value points to sandbox: #{@node[:languages][:ruby][:ruby_bin]}" if test_failed
    Chef::Log.info("== PASS ==")
  end
end

ruby_block "gems_dir should not point to sandbox" do
  block do
   test_failed = ( @node[:languages][:ruby][:gems_dir] =~ /sandbox/ )
   raise "ERROR: ohai ruby plugin: 'gems_dir' value points to sandbox: #{@node[:languages][:ruby][:gems_dir]}" if test_failed
   Chef::Log.info("== PASS ==")
  end
end