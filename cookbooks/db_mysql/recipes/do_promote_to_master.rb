#
# Cookbook Name:: db_mysql
# Recipe:: do_promote_to_master
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'db_mysql::do_lookup_master'

# Find current master
ruby_block "slave check" do
  only_if do true end
  block do
    raise "FATAL: this instance is already a master!" if node[:db][:this_is_master]
    raise "FATAL: Unable to lookup current master server" unless node[:db][:current_master]
  end
end

x = node[:db_mysql][:log_bin]
logbin_dir = x.gsub(/#{::File.basename(x)}$/, "")
directory logbin_dir do
  action :create
  recursive true
  owner 'mysql'
  group 'mysql' 
end

# Set read/write in my.cnf
@node[:db_mysql][:tunable][:read_only] = 0
# Enable binary logging in my.cnf
@node[:db_mysql][:log_bin_enabled] = true
include_recipe 'db_mysql::setup_my_cnf'

database "newmaster" do
  only_if do true end
  not_if do false end # http://tickets.opscode.com/browse/CHEF-894
  action :promote
end

include_recipe 'db_mysql::do_tag_as_master'  
include_recipe 'db_mysql::setup_master_backup'
include_recipe 'db_mysql::do_backup'

remote_recipe "enable slave backups on oldmaster" do
  recipe "db_mysql::setup_slave_backup"
  recipients_tags "rs_dbrepl:master_instance_uuid=#{node[:db][:current_master]}"
end
