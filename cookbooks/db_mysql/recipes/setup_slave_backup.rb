# Cookbook Name:: db_mysql
# Recipe:: setup_slave_backups
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

log "Disabling master continuous backup cron job (if exists)"
cron "Master continuous backups" do
  user "root"
  action :delete
end

log "Enabling slave continuous backup cron job:#{node[:db][:backup][:minute]} #{node[:db][:backup][:slave_hour]}"
cron "Slave continuous backups" do
  minute "#{node[:db][:backup][:slave][:minute]}"
  hour "#{node[:db][:backup][:slave][:hour]}"
  user "root"
  command "rs_run_recipe -n \"db_mysql::do_backup\" 2>&1 > /var/log/mysql_cron_backup.log"
  action :create
end
