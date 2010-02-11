#
# Cookbook Name:: db_mysql
# Recipe:: setup_master_backup
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
#

log "Disabling slave continuous backup cron job (if exists):"
cron "Slave continuous backups" do
  user "root"
  action :delete
end

log "Enabling master continuous backup cron job:#{node[:db][:backup][:minute]} #{node[:db][:backup][:master_hour]}"
cron "Master continuous backups" do
  minute "#{node[:db][:backup][:master][:minute]}"
  hour "#{node[:db][:backup][:master][:hour]}"
  user "root"
  command "rs_run_recipe -n \"db_mysql::do_backup\" 2>&1 > /var/log/mysql_cron_backup.log"
  action :create
end
