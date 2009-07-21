
#setup timezone
link "/usr/share/zoneinfo/#{@node[:system][:timezone]}" do 
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
template @node[:system][:logrotate_config] do
  source "syslog-ng.conf"
end

