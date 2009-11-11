#
# Cookbook Name:: db_mysql
# Recipe:: do_backup
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

require 'fileutils'

include_recipe "db_mysql::do_lookup_master"

# Check that either this instance is the current master -or- this instance is 
# replicating (seconds behind master check)
# NOTE: you can override this check, using node[:db][:backup][:force]
# used in do_promote_to_master:
database "localhost" do
  not_if do false end
  action :pre_backup_sanity_check
end

# Sync the filesystem before lock
block_device node[:db][:backup][:block_device_resource] do
  action :sync_fs
end

# Flush database with read-lock
database "localhost" do
  not_if do false end
  action [:lock, :write_mysql_backup_info]
end

# Sync again after flush and lock for more consistent backup
block_device node[:db][:backup][:block_device_resource] do
  action :sync_fs
  fs_sync_timeout 30
end

# Take a snapshot
block_device node[:db][:backup][:block_device_resource] do
  action :take_snapshot
end

# Release database read-lock
database "localhost" do
  not_if do false end
  action :unlock
end

# Should the database provider construct the list and store in the node?
block_device node[:db][:backup][:block_device_resource] do
  lineage node[:db][:backup][:lineage_override] || node[:db][:backup][:lineage]
  action :backup
end

file node[:rs_utils][:mysql_binary_backup_file] do
  action :touch
  owner "nobody"
  group value_for_platform([ "centos", "redhat", "suse" ] => {"default" => "nobody"}, "default" => "nogroup")
end
