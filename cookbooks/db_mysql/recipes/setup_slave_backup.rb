Chef::Log.info "Disabling master continuous backup cron job (if exists)"
cron "Master continuous backups" do
  user "root"
  action :delete
end

Chef::Log.info "Enabling slave continuous backup cron job:#{node[:db][:backup][:minute]} #{node[:db][:backup][:slave_hour]}"
cron "Slave continuous backups" do
  minute "#{node[:db][:backup][:slave][:minute]}"
  hour "#{node[:db][:backup][:slave][:hour]}"
  user "root"
  command "rs_run_recipe -n \"db_mysql::do_backup\" 2>&1 > /var/log/mysql_cron_backup.log"
  action :create
end
