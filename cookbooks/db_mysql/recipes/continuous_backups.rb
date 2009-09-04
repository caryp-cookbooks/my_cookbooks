# Cookbook Name:: db_mysql
# Recipe:: continuous_backups
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

rs_tools "dbtools-0.18.12.tgz"

package "xfsprogs" # needed for xfs freeze

# MySQL database cron task log file
db_log = "/var/log/mysql_database_cron.log"
db_basedir="/opt/rightscale/db"

# install the cron backup script template, substituting the variables
template "/usr/local/bin/mysql-binary-backup.rb" do
  source "cron-backup-ebs.erb"
  mode "0700"
  variables(
    :run_file => "/var/run/mysql-binary-backup", # The run file to create for collectd to monitor
    :lock_file => "/usr/local/lockfile",         # the lock file to use
    :max_lag => "60"
    )
end

log "Template reconfiguration complete."

# setup backup options
max_snaps = @node[:db_mysql][:backup][:maximum_snapshots]
keep_daily = @node[:db_mysql][:backup][:keep_daily]
keep_weekly = @node[:db_mysql][:backup][:keep_daily]
keep_monthly = @node[:db_mysql][:backup][:keep_daily]
keep_yearly = @node[:db_mysql][:backup][:keep_daily]
backup_options = "--max-snapshots #{max_snaps} -D #{keep_daily} -W #{keep_weekly} -M #{keep_monthly} -Y #{keep_yearly}"

# install the same backup script to run at the slave and master frequency
# it will only execute on 1 since it cannot be both a master and a slave...
cron "MySQL Slave Backup" do
  minute @node[:db_mysql][:backup][:frequency][:slave]
  command "/usr/local/bin/mysql-binary-backup.rb --if-slave #{backup_options} >> #{db_log} 2>&1"
end

cron "MySQL Master Backup" do
  minute @node[:db_mysql][:backup][:frequency][:master]
  command "/usr/local/bin/mysql-binary-backup.rb --if-master #{backup_options} >> #{db_log} 2>&1"
end

# Setup the logrotate of MySQL database cron log. It keeps the log file for a week
template "/etc/logrotate.d/mysql_backup_cron" do
  source "logrotate_weekly.erb"
  variables("log_file_path" => "#{db_log}")
end



