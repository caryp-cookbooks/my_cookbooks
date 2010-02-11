#
# Cookbook Name:: db_mysql
# Recipe:: do_restore_and_become_master
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

include_recipe "db_mysql::do_restore"
include_recipe "db_mysql::do_tag_as_master"
node[:db][:backup][:force] = true
include_recipe "db_mysql::setup_master_backup"
include_recipe "db_mysql::do_backup" # kick-off first backup so that slaves can init from this master
