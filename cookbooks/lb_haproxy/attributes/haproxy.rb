#
# Required
#
#  logical name for the application (balancing group) to use in 
set_unless[:lb_haproxy][:applistener_name] = nil
set_unless[:lb_haproxy][:host]= nil
set_unless[:lb_haproxy][:backend_name]= nil
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
set_unless[:lb_haproxy][:stats_uri] = "/haproxy-status"
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
# default apache is worker model -- use prefork for single thread

case platform
when "redhat","centos","fedora","suse"
  set_unless[:lb_haproxy][:apache_name] = "httpd"
else
  set_unless[:lb_haproxy][:apache_name] = "apache2"
end
