# Cookbook Name:: db_mysql
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

#
# Required attributes
#
set_unless[:db_mysql][:admin_user] = nil
set_unless[:db_mysql][:admin_password] = nil
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
set_unless[:db_mysql][:server_usage] = "dedicated"  # or "shared"
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
set_unless[:db_mysql][:datadir_relocate] = "/mnt/mysql"
set_unless[:db_mysql][:log_bin] = "/mnt/mysql-binlogs/mysql-bin"
set_unless[:db_mysql][:tmpdir] = "/tmp"
set_unless[:db_mysql][:datadir] = "/var/lib/mysql"
set_unless[:db_mysql][:bind_address] = ipaddress

#
# Platform specific attributes
#
case platform
when "redhat","centos","fedora","suse"
	set_unless[:db_mysql][:socket] = "/var/run/mysqld/mysqld.sock"
  set_unless[:db_mysql][:basedir] = "/var/lib"
  set_unless[:db_mysql][:packages_uninstall] = ""
  set_unless[:db_mysql][:packages_install] = [
    "perl-DBD-MySQL", "mysql-server", "mysql-devel", "mysql-connector-odbc", 
    "mysqlclient14-devel", "mysqlclient14", "mysqlclient10-devel", "mysqlclient10", 
    "krb5-libs"
	]
  set_unless[:db_mysql][:log] = ""
  set_unless[:db_mysql][:log_error] = "" 
when "debian","ubuntu"
  set_unless[:db_mysql][:socket] = "/var/run/mysqld/mysqld.sock"
  set_unless[:db_mysql][:basedir] = "/usr"
  set_unless[:db_mysql][:packages_uninstall] = "apparmor"
  set_unless[:db_mysql][:packages_install] = ["mysql-server-5.0", "tofrodos"]
  set_unless[:db_mysql][:log] = "log = /var/log/mysql.log"
  set_unless[:db_mysql][:log_error] = "log_error = /var/log/mysql.err" 
else
  set_unless[:db_mysql][:socket] = "/var/run/mysqld/mysqld.sock"
  set_unless[:db_mysql][:basedir] = "/usr"
  set_unless[:db_mysql][:packages_uninstall] = ""
  set_unless[:db_mysql][:packages_install] = ["mysql-server-5.0"]
  set_unless[:db_mysql][:log] = "log = /var/log/mysql.log"
  set_unless[:db_mysql][:log_error] = "log_error = /var/log/mysql.err"
end
