# Cookbook Name:: db_mysql
# Recipe:: setup_admin_privileges
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

db_mysql_setup_privileges "setup admin privileges" do
  preset "administrator"
  username @node[:db_mysql][:admin_user]
  password @node[:db_mysql][:admin_password]
end
