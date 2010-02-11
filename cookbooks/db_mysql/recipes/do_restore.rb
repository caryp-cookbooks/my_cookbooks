#
# Cookbook Name:: db_mysql
# Recipe:: do_restore
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
DATABASE_NAME = "localhost"

# Check database is pristine 
database DATABASE_NAME do
  action :require_pristine
  not_if do @node[:db][:restore][:force] end
end

service "mysql" do
  only_if do true end
  action :stop
end

# Recreate empty data directory
directory @node[:db_mysql][:datadir_relocate] do
  action [:delete, :create]
  recursive true
  owner 'mysql'
  group 'mysql' 
end

# Do restore
block_device node[:db][:backup][:block_device_resource] do
  lineage node[:db][:backup][:lineage_override] || node[:db][:backup][:lineage]
  restore_root node[:db][:backup][:mount_point]
  action :restore
end

# Recreate mysql-binlogs directory
x = node[:db_mysql][:log_bin]
logbin_dir = x.gsub(/#{::File.basename(x)}$/, "")
directory logbin_dir do
  action [ :create ]
  recursive true
  owner 'mysql'
  group 'mysql' 
end

ruby_block "kill master.info" do
  only_if do true end
  block do
    require 'fileutils'
    FileUtils.rm_rf(File.join(node[:db_mysql][:datadir], 'master.info'))
    FileUtils.chown_R('mysql', 'mysql', node[:db_mysql][:datadir])
  end
end

# Service provider uses the status command to decide if it 
# has to run the start command again.
service "mysql" do
  only_if do true end
  action :start
end

database DATABASE_NAME do
  action :grant_replication_slave
  not_if do false end # http://tickets.opscode.com/browse/CHEF-894
end

include_recipe "db_mysql::setup_admin_privileges"
