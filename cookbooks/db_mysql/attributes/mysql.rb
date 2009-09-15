# Cookbook Name:: db_mysql
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

#
# Required attributes
#
set_unless[:db_mysql][:replication_user] = nil
set_unless[:db_mysql][:replication_password] = nil
# dns 
set_unless[:db_mysql][:dns][:user] = nil
set_unless[:db_mysql][:dns][:password] = nil
set_unless[:db_mysql][:dns][:master_id] = nil
set_unless[:db_mysql][:dns][:master_name] = nil
# backup 
set_unless[:db_mysql][:backup][:prefix] = nil

#
# Recommended attributes
#
# backup 
set_unless[:db_mysql][:backup][:frequency][:master] = 5 + rand(24) # master done between 5-29
set_unless[:db_mysql][:backup][:frequency][:slave] = 30 + rand(29) # slave done between 30-59
set_unless[:db_mysql][:backup][:keep_daily] = "14"
set_unless[:db_mysql][:backup][:keep_weekly] = "6"
set_unless[:db_mysql][:backup][:keep_monthly] = "12"
set_unless[:db_mysql][:backup][:keep_yearly] = "2"
set_unless[:db_mysql][:backup][:maximum_snapshots]= "60"

#
# Optional attributes
#
set_unless[:db_mysql][:dns][:ttl_limit] = "120"      

