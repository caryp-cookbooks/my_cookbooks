#
# Cookbook Name:: lb_haproxy
# Recipe:: install_haproxy
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
#include_recipe "haproxy"
package "haproxy" do
  action :install
end

service "haproxy" do
  supports :restart => true, :status => true, :reload => true
  action [:enable]
end

directory "/home/haproxy" do
  owner "haproxy"
  group "haproxy"
  mode 0755
  recursive true
  action :create
end

default_init_file="/etc/default/haproxy"
bash "Fix haproxy init defaults" do
  user "root"
  code <<-EOH
  echo "" >> /etc/default/haproxy 
  echo "ENABLED=1" >> /etc/default/haproxy
  echo "CONFIG=/home/haproxy/rightscale_lb.cfg" >> /etc/default/haproxy
  EOH
end

template  "/home/haproxy/rightscale_lb.cfg" do
  source "haproxy_http.erb"
  owner "haproxy"
  group "haproxy"
  mode "0400"
  stats_uri = "stats uri #{@node[:lb_haproxy][:stats_uri]}" unless "#{@node[:lb_haproxy][:stats_uri]}".empty?
  stats_auth = "stats auth #{@node[:lb_haproxy][:stats_user]}:#{@node[:lb_haproxy][:stats_password]}" unless \
             "#{@node[:lb_haproxy][:stats_user]}".empty? || "#{@node[:lb_haproxy][:stats_password]}".empty?
  health_uri = "option httpchk GET #{@node[:lb_haproxy][:health_check_uri]}" unless "#{@node[:lb_haproxy][:health_check_uri]}".empty?
  variables ( :stats_uri_line => stats_uri, :stats_auth_line => stats_auth, :health_uri_line => health_uri )
  notifies :restart, resources(:service => "haproxy"), :immediately
end

#ruby "Do config file changes" do
#  code <<-EOH
#  if "#{@node[:lb_haproxy][:stats_uri]}" == nil || "#{@node[:lb_haproxy][:stats_uri]}" == ""
#    #Disable stats if input not set
#    if "#{@node[:lb_haproxy][:stats_user]}" != nil &&  "#{@node[:lb_haproxy][:stats_user]}" != ""
#    else # Disable the password if no user given.
#  EOH
#end
log "RightScale LB installation and configuration complete"

right_link_tag "rs_loadbal:state=active"
