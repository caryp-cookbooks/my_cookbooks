#install server command for ubuntu
package "sysvconfig" do
  #only_if @node[:platform] == "ubuntu"
end

#setup timezone
link "/usr/share/zoneinfo/#{@node[:server][:timezone]}" do 
  to "/etc/localtime"
end

#configure mail
package "postfix"

bash "configure_postfix" do 
  code <<-EOH
    sed -i 's/inet_interfaces = localhost/#inet_interfaces = localhost/' /etc/postfix/main.cf
    sed -i 's/#inet_interfaces = all/inet_interfaces = all/' /etc/postfix/main.cf 
    sed -i "s/mydestination = \$myhostname\, localhost\.\$mydomain\, localhost/mydestination = \$myhostname, localhost\.\$mydomain\, localhost\, $EC2_LOCAL_HOSTNAME/" /etc/postfix/main.cf 
  EOH
end

service "postfix" do 
  supports :start => true, :stop => true, :restart => true
  action [ :enable, :restart ]
end

#configure syslog
package "syslog-ng" 

execute "ensure_dev_null" do 
  creates "/dev/null.syslog-ng"
  command "mknod /dev/null.syslog-ng c 1 3"
end

template "/etc/syslog-ng/syslog-ng.conf" do
  source "syslog.erb"
end

service "syslog-ng" do
  supports :start => true, :stop => true, :restart => true
  action [ :enable, :restart ]
end

bash "configure_logrotate_for_syslog" do 
  code <<-EOH
    perl -p -i -e 's/weekly/daily/; s/rotate\s+\d+/rotate 7/' /etc/logrotate.conf
    [ -z "$(grep -lir "missingok" #{@node[:server][:logrotate_config]}_file)" ] && sed -i '/sharedscripts/ a\    missingok' #{@node[:server][:logrotate_config]}
    [ -z "$(grep -lir "notifempty" #{@node[:server][:logrotate_config]}_file)" ] && sed -i '/sharedscripts/ a\    notifempty' #{@node[:server][:logrotate_config]}
  EOH
end

directory "/var/spool/oldmail" do 
  recursive true 
  mode "775"
  owner "root"
  group "mail"
end

remote_file "/etc/logrotate.d/mail" do 
  source "mail"
end

#configure collectd
package "collectd" 

package "liboping0" do
  #only_if @node[:platform] == "ubuntu"
end

directory @node[:server][:collectd_plugin_dir] do
  recursive true
end

template @node[:server][:collectd_config] do 
  source "collectd.config.erb"
end

bash "configure_process_monitoring" do 
  code <<-EOH
    echo "LoadPlugin Processes" > #{@node[:server][:collectd_plugin_dir]}/processes.conf
    echo "<Plugin processes>" >> #{@node[:server][:collectd_plugin_dir]}/processes.conf
    echo '  process "collectd"' >> #{@node[:server][:collectd_plugin_dir]}/processes.conf
    #TODO: make this work!
    #for p in "#{@node[:server][:process_list]}" ; do
      #echo "  process \"$p\"" >> #{@node[:server][:collectd_plugin_dir]}/processes.conf
    #done
    echo "</Plugin>" >> #{@node[:server][:collectd_plugin_dir]}/processes.conf
  EOH
end

#configure cron
cron "collectd_restart" do 
  day "4"
  command "service collectd restart"
end

service "cron" do 
  service_name "crond" if @node[:platform] == "centos" 
  action :restart
end

service "collectd" do 
  #action :restart
  action :nothing
end

#install private key
execute "add_ssh_key" do 
  command "echo #{@node[:rightscale][:ssh_key]} >> /root/.ssh/authorized_keys"
end
