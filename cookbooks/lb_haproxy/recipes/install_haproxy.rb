#
# Cookbook Name:: lb_haproxy
# Recipe:: install_haproxy
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

rs_tools "rightscale_lbtools-0.13.6.tgz"

package "haproxy" do
  action :install
end

service "haproxy" do
  supports :restart => true, :status => true, :start => true, :stop => true
  action [:enable]
end

directory "/home/haproxy" do
  owner "haproxy"
  group "haproxy"
  mode 0755
  recursive true
  action :create
end

template "/etc/default/haproxy" do
  source "default_haproxy.erb"
  owner "root"
  notifies :restart, resources(:service => "haproxy")
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
  variables( :stats_uri_line => stats_uri, :stats_auth_line => stats_auth, :health_uri_line => health_uri )
  notifies :restart, resources(:service => "haproxy")
end

right_link_tag "loadbalancer:lb=#{@node[:lb_haproxy][:applistener_name]}"

log "RightScale LB installation and configuration complete"

