# Cookbook Name:: app_rails
# Recipe:: do_db_restore
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

# grab application source from remote repository
do_mysqldump_restore "do database restore" do
  url @node[:rails][:code][:url]
  branch @node[:rails][:code][:branch] 
  user @node[:rails][:code][:user]
  credentials @node[:rails][:code][:credentials]
  file_path @node[:rails][:db_mysqldump_file_path]
  schema_name @node[:rails][:db_schema_name]
end

log "user: #{@node[:rails][:db_app_user]}"
log "password: #{@node[:rails][:db_app_passwd]}"

db_mysql_setup_privileges "setup admin privileges" do
  preset 'user'
  username @node[:rails][:db_app_user]
  password @node[:rails][:db_app_passwd]
end
