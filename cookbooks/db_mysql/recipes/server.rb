# Cookbook Name:: db_mysql
# Recipe:: server
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

include_recipe "mysql::client"

# throw an error of the DNS TTL is too high
bash "check dynamic dns ttl" do
  user "root"
  code <<-EOH
    set -xe
    dnsttl=`dig #{@node[:db_mysql][:dns][:master_name]} | grep ^#{@node[:db_mysql][:dns][:master_name]}| awk '{ print $2}'`
   if [ $dnsttl -gt #{@node[:db_mysql][:dns_ttl_limit]} ]; then
   logger -t RightScale "Master DB DNS TTL set too high.  Must be set <= #{@node[:db_mysql][:dns_ttl_limit]}" 
     exit 1
   fi
   logger -t RightScale "Master DB DNS TTL: $dnsttl"
  EOH
end

#todo: use the log resource here
puts "#{@node[:db_mysql][:server_usage]}-#{@node[:ec2][:instance_type]}"

case node[:platform]
when "debian","ubuntu"

  directory "/var/cache/local/preseeding" do
    owner "root"
    group "root"
    mode "755"
    recursive true
  end
  
  execute "preseed mysql-server" do
    command "debconf-set-selections /var/cache/local/preseeding/mysql-server.seed"
    action :nothing
  end

  template "/var/cache/local/preseeding/mysql-server.seed" do
    source "mysql-server.seed.erb"
    owner "root"
    group "root"
    mode "0600"
    notifies :run, resources(:execute => "preseed mysql-server"), :immediately
  end
  
  remote_file "/etc/mysql/debian.cnf" do
    source "debian.cnf"
  end
end

package "mysql-server" do
  action :install
end

# install other packages we require
@node[:db_mysql][:packages_install].each do |p| 
  package p 
end unless @node[:db_mysql][:packages_install] == nil

# uninstall other packages we don't
@node[:db_mysql][:packages_uninstall].each do |p| 
   package p do
     action :remove
   end
end unless @node[:db_mysql][:packages_uninstall] == nil

service "mysql" do
  service_name value_for_platform([ "centos", "redhat", "suse" ] => {"default" => "mysqld"}, "default" => "mysql")  
  supports :status => true, :restart => true, :reload => true
  action :enable
end

# Create it so mysql can use it if configured
file "/var/log/mysqlslow.log" do
  owner "mysql"
  group "mysql"
end

# Initialize the binlog dir
binlog = `dirname #{@node[:db_mysql][:log_bin]}`.strip
directory binlog do
  owner "mysql"
  group "mysql"
  recursive true
end

# Disable the "check_for_crashed_tables" for ubuntu
case node[:platform]
when "debian","ubuntu"
  execute "sed -i 's/^.*check_for_crashed_tables.*/  #check_for_crashed_tables;/g' /etc/mysql/debian-start"
end

# Drop in best practice replacement for mysqld startup.  Timeouts enabled.
template value_for_platform([ "centos", "redhat", "suse" ] => {"default" => "/etc/init.d/mysqld"}, "default" => "/etc/init.d/mysql") do
  source "init-mysql.erb"
  mode "0755"  
end

template value_for_platform([ "centos", "redhat", "suse" ] => {"default" => "/etc/my.cnf"}, "default" => "/etc/mysql/my.cnf") do
  source "my.cnf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :server_id => "#{Time.now.to_i}"
  )
  notifies :restart, resources(:service => "mysql"), :immediately
end

if (! FileTest.directory?(node[:db_mysql][:datadir_relocate]))
  
  service "mysql" do
    action :stop
  end
  
  execute "install-mysql" do
    command "mv #{node[:db_mysql][:datadir]} #{node[:db_mysql][:datadir_relocate]}"
  end
  
  link node[:db_mysql][:datadir] do
   to node[:db_mysql][:datadir_relocate]
  end
  
  directory @node[:db_mysql][:datadir_relocate] do
    owner "mysql"
    group "mysql"
    mode "0775"
    recursive true
  end
  
  service "mysql" do
    action :start
  end
end
 
## Fix Privileges 4.0+
execute "/usr/bin/mysql_fix_privilege_tables"


