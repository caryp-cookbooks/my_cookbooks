#
# Cookbook Name:: db_mysql
# Recipe:: do_init_slave
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

include_recipe "db_mysql::do_lookup_master"
include_recipe "db_mysql::do_restore"

database "localhost" do
  not_if do false end # http://tickets.opscode.com/browse/CHEF-894
  action [ :wipe_existing_runtime_config ]
end

# disable binary logging
@node[:db_mysql][:log_bin_enabled] = false
include_recipe 'db_mysql::setup_my_cnf'

# empty out the binary log dir
x = node[:db_mysql][:log_bin]
logbin_dir = x.gsub(/#{::File.basename(x)}$/, "")
directory logbin_dir do
  action [:delete, :create]
  recursive true
  owner 'mysql'
  group 'mysql' 
end

# ensure_db_started
# service provider uses the status command to decide if it 
# has to run the start command again.
10.times do
  service "mysql" do
    only_if do true end
    action :start
  end
end

# checks for valid backup and that current master matches backup
database "localhost" do
  not_if do false end # http://tickets.opscode.com/browse/CHEF-894
  action [ :validate_backup, 
           :reconfigure_replication,
           :grant_replication_slave ]
end

database "localhost" do
  not_if do false end # http://tickets.opscode.com/browse/CHEF-894
  action :do_query
  query "SET GLOBAL READ_ONLY=1"
end
@node[:db_mysql][:tunable][:read_only] = 1
include_recipe 'db_mysql::setup_my_cnf'

include_recipe 'db_mysql::setup_slave_backup'
