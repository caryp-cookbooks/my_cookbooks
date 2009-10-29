# Cookbook Name:: lb_haproxy
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

#
# Required
#
#  logical name for the application (balancing group) to use in 
set_unless[:lb_haproxy][:applistener_name] = nil
set_unless[:lb_haproxy][:host]= nil
#
# Recommended
#
#  template that haproxy config should use (e.g. haproxy_http)
set_unless[:lb_haproxy][:template_name] = "haproxy_http"
#  address that haproxy should bind to 
set_unless[:lb_haproxy][:bind_address] = "127.0.0.1"
#  port that haproxy should bind to 
set_unless[:lb_haproxy][:bind_port] = 85

#
# Optional
#

#  URI for the load balancer to use to check the health of a server (only used when using http templates)
set_unless[:lb_haproxy][:health_check_uri] = ""
#  URI that the load balancer uses to publish its status 
set_unless[:lb_haproxy][:stats_uri] = ""
#  Username required to access to the haproxy stats page
set_unless[:lb_haproxy][:stats_user] = ""
#  Password required to access to the haproxy stats page
set_unless[:lb_haproxy][:stats_password] = ""
set_unless[:lb_haproxy][:vhost_port] = ""
set_unless[:lb_haproxy][:session_stickiness] = ""
set_unless[:lb_haproxy][:max_conn_per_server] = "500"

#
# Overrides
#

set_unless[:lb_haproxy][:cfg_file] = "/home/haproxy/rightscale_lb.cfg"

case platform
when "redhat","centos","fedora","suse"
  set_unless[:lb_haproxy][:apache_name] = "httpd"
else
  set_unless[:lb_haproxy][:apache_name] = "apache2"
end
