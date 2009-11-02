maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures lb_haproxy"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

recipe "lb_haproxy::default", "Installs haproxy"
recipe "lb_haproxy::install_haproxy", "Installs haproxy"
recipe "lb_haproxy::do_attach_request", "Attaches an application server to the load balancer"
recipe "lb_haproxy::do_detach_request", "Detaches an application server from the load balancer"
recipe "lb_haproxy::do_attach", "Adds the new application server to the haproxy configuration file"
recipe "lb_haproxy::do_detach", "Removes the new application server to the haproxy configuration file"
recipe "lb_haproxy::setup_reverse_proxy_config", "Configures apache reverse proxy"
recipe "lb_haproxy::setup_load_balancer_vhost", "Configures apache reverse proxy"

attribute "lb_haproxy/applistener_name",
  :display_name => "Applistener Name",
  :description => "Sets the name of the HAProxy load balance pool on frontends in /home/haproxy/rightscale_lb.cfg. Application severs will join this load balance pool by using this name.  Ex: www",
  :required => true,
  :default => nil

attribute "lb_haproxy/host",
  :display_name => "LB Host",
  :description => "This is the fully qualified hostname of all the servers that have HAProxy installed on them.  For example, if www.domain.com has two FEs with EIPs and HAProxy installed on them, you would enter www.domain.com as the LB_HOSTNAME.  It is necessary that these hosts be registered with DNS so that the connect script can find all the HAProxy servers and update their configuration files.",
  :required => true,
  :default => nil

attribute "lb_haproxy/template_name",
  :display_name => "Haproxy Config Template",
  :description => "This is the name of the base HAProxy configuration file that will be used.  This file gets modified according to the defined inputs.  The current values are: haproxy_http and haproxy_tcp.  Ex: haproxy_http",
  :required => false,
  :default => "haproxy_http"

attribute "lb_haproxy/bind_address",
  :display_name => "Bind Address",
  :description => "The IP address that HAProxy will be listening on.  Normally, it should be set to localhost.  Ex: 127.0.0.1",
  :required => false,
  :default => "127.0.0.1"

attribute "lb_haproxy/bind_port",
  :display_name => "Bind Port",
  :description => "The port number that HAProxy will be listening on.  Normally, it's set to 85. If you have multiple load balance pools, each pool must be assigned to a different port.  Ex: 85",
  :required => false,
  :default => "85"

attribute "lb_haproxy/stats_uri",
  :display_name => "Status URI",
  :description => "The URI for the HAProxy statistic report page, which lists the current session, queued session, response error, health check error, server status, etc., for each HAProxy group.  Ex: /haproxy-status",
  :required => false,
  :default => ""

attribute "lb_haproxy/stats_user",
  :display_name => "Status Page Username",
  :description => "The username that's required to access the HAProxy statistic report page.",
  :required => false,
  :default => ""

attribute "lb_haproxy/stats_password",
  :display_name => "Status Page Password",
  :description => "The password that's required to access the HAProxy statistic report page.",
  :required => false,
  :default => ""

attribute "lb_haproxy/health_check_uri",
  :display_name => "Health Check URI",
  :description => " URI for the load balancer to use to check the health of a server (only used when using http templates)",
  :required => false,
  :default => ""
