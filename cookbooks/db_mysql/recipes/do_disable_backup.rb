#
# Cookbook Name:: db_mysql
# Recipe:: do_cron_backup_disable
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

log "Disabling master/slave continuous backup cron jobs"

cron "Slave continuous backups" do
  user "root"
  action :delete
end

cron "Master continuous backups" do
  user "root"
  action :delete
end

