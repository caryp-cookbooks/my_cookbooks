#
# Required
#
set_unless[:db_mysql][:dns][:user] = nil
set_unless[:db_mysql][:dns][:password] = nil
set_unless[:db_mysql][:dns][:master_id] = nil
set_unless[:db_mysql][:dns][:master_name] = nil

set_unless[:db_mysql][:backup][:prefix] = nil


#
# Recommended
#
set_unless[:db_mysql][:server_usage] = :dedicated  # or :shared

set_unless[:db_mysql][:backup][:maximum_snapshots]= 60
#  offset the start time by random number between 5-59. Units are in minutes. FIXME: allow all cron units
set_unless[:db_mysql][:backup][:frequency][:master] = 5 + rand(24) # master done between 5-29
set_unless[:db_mysql][:backup][:frequency][:slave] = 30 + rand(29) # slave done between 30-59
set_unless[:db_mysql][:backup][:keep_daily] = 14
set_unless[:db_mysql][:backup][:keep_weekly] = 6
set_unless[:db_mysql][:backup][:keep_monthly] = 12
set_unless[:db_mysql][:backup][:keep_yearly] = 2

#
# Optional
#
set_unless[:db_mysql][:init_timeout] = nil
set_unless[:db_mysql][:dns_ttl_limit] = 120      

set_unless[:db_mysql][:datadir_relocate] = "/mnt/mysql"
set_unless[:db_mysql][:log_bin] = "/mnt/mysql-binlogs/mysql-bin"
set_unless[:db_mysql][:tmpdir] = "/tmp"

set_unless[:db_mysql][:datadir] = "/var/lib/mysql"
set_unless[:db_mysql][:bind_address] = ipaddress

case platform
when "redhat","centos","fedora","suse"
	set_unless[:db_mysql][:socket] = "/var/run/mysqld/mysqld.sock"
  set_unless[:db_mysql][:basedir] = "/var/lib"
  set_unless[:db_mysql][:packages_uninstall] = nil
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
  set_unless[:db_mysql][:packages_uninstall] = nil
  set_unless[:db_mysql][:packages_install] = ["mysql-server-5.0"]
  set_unless[:db_mysql][:log] = "log = /var/log/mysql.log"
  set_unless[:db_mysql][:log_error] = "log_error = /var/log/mysql.err"
end
