# Cookbook Name:: db_mysql
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

set_unless[:db][:replication][:user] = nil
set_unless[:db][:replication][:password] = nil

set_unless[:db][:admin][:user] = 'root'
set_unless[:db][:admin][:password] = nil

set_unless[:db][:backup][:lineage] = nil
set_unless[:db][:backup][:lineage_override] = nil 
set_unless[:db][:backup][:block_device_resource] = "default" # hardcoded for now 

# calculate recommended backup times for master/slave

set_unless[:db][:backup][:master][:minute] = 5 + rand(54) # backup starts random time between 5-59
set_unless[:db][:backup][:master_hour] = rand(23) #once a day, random hour

# TBD: do we want to override the user setting? Disabled for now for testing purposes
#user_set = true if node[:db][:backup][:slave][:minute]
set_unless[:db][:backup][:slave][:minute] = 5 + rand(54) # backup starts random time between 5-59

if db[:backup][:slave][:minute] == db[:backup][:master][:minute]
  log_msg = "WARNING: detected master and slave backups collision."
#  unless user_set
    db[:backup][:slave][:minute] = db[:backup][:slave][:minute].to_i / 2 
    log_msg += "  Changing slave minute to avoid collision: #{db[:backup][:slave][:minute]}"
#  end
  Chef::Log.info log_msg
end

set_unless[:db][:backup][:slave_hour] = "*" # every hour

set_unless[:db][:dns][:master_id] = nil

set_unless[:db][:backup][:mount_point] = "/mnt"
set_unless[:db][:backup][:slave][:max_allowed_lag] = 60
set_unless[:db][:backup][:force] = false
set_unless[:db][:restore][:force] = false # for skipping pristine check

set_unless[:dns][:user] = nil
set_unless[:dns][:password] = nil
