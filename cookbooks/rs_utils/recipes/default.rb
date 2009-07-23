#install rs_utils command for ubuntu
package "sysvconfig" do
  only_if { @node[:platform] == "ubuntu" }
end

#setup timezone
link "/usr/share/zoneinfo/#{@node[:rs_utils][:timezone]}" do 
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
    [ -z "$(grep -lir "missingok" #{@node[:rs_utils][:logrotate_config]}_file)" ] && sed -i '/sharedscripts/ a\    missingok' #{@node[:rs_utils][:logrotate_config]}
    [ -z "$(grep -lir "notifempty" #{@node[:rs_utils][:logrotate_config]}_file)" ] && sed -i '/sharedscripts/ a\    notifempty' #{@node[:rs_utils][:logrotate_config]}
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
  only_if { @node[:platform] == "ubuntu" }
end

directory @node[:rs_utils][:collectd_plugin_dir] do
  recursive true
end

template @node[:rs_utils][:collectd_config] do 
  source "collectd.config.erb"
end

bash "configure_process_monitoring" do 
  code <<-EOH
    echo "LoadPlugin Processes" > #{@node[:rs_utils][:collectd_plugin_dir]}/processes.conf
    echo "<Plugin processes>" >> #{@node[:rs_utils][:collectd_plugin_dir]}/processes.conf
    echo '  process "collectd"' >> #{@node[:rs_utils][:collectd_plugin_dir]}/processes.conf
    #TODO: make this work!
    #for p in "#{@node[:rs_utils][:process_list]}" ; do
      #echo "  process \"$p\"" >> #{@node[:rs_utils][:collectd_plugin_dir]}/processes.conf
    #done
    echo "</Plugin>" >> #{@node[:rs_utils][:collectd_plugin_dir]}/processes.conf
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
  command "echo #{@node[:rightscale1][:ssh_key]} >> /root/.ssh/authorized_keys"
end

#set hostname
execute "set_hostname" do
  command "hostname #{@node[:rs_utils][:hostname]}" 
end