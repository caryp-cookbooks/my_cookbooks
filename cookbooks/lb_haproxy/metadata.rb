maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures lb_haproxy"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

recipe "lb_haproxy::default", "Installs haproxy"
recipe "lb_haproxy::install_haproxy", "Installs haproxy"
recipe "lb_haproxy::do_app_to_HA_proxy_connect", "Connects HA proxy server"
recipe "lb_haproxy::do_app_to_HA_proxy_disconnect", "Disconnects HA proxy server"
recipe "lb_haproxy::do_app_to_local_HA_proxy", "Connects app to local haproxy server"
recipe "lb_haproxy::do_HA_proxy_config_get", "Get the haproxy configuration"
recipe "lb_haproxy::setup_reverse_proxy_config", "Configures apache reverse proxy"
recipe "lb_haproxy::setup_load_balancer_vhost", "Configures apache reverse proxy"
recipe "lb_haproxy::install_lb_tools", "Installs Rightscale Load Balancer tools"
recipe "lb_haproxy::test", "Does something"


attribute "lb_haproxy",
  :display_name => "lb_haproxy hash",
  :description => "Hash of attributes",
  :type => "hash"

attribute "lb_haproxy/applistener_name",
  :display_name => "Applistener Name",
  :description => "Logical name for the application (balancing group) to use (e.g. mylistener)",
  :required => true,
  :default => nil

attribute "lb_haproxy/backend_name",
  :display_name => "Backend Name",
  :description => "Unique name for backend (e.g. cloud uuid)",
  :required => true,
  :default => nil

attribute "lb_haproxy/host",
  :display_name => "LB Host",
  :description => "The hostname where haproxy is installed",
  :required => true,
  :default => nil

attribute "lb_haproxy/template_name",
  :display_name => "Haproxy Config Template",
  :description => "Template that haproxy config should use (e.g. haproxy_http)",
  :required => false,
  :default => "haproxy_http"

attribute "lb_haproxy/bind_address",
  :display_name => "Bind Address",
  :description => " Address that haproxy should bind to",
  :required => false,
  :default => "127.0.0.1"

attribute "lb_haproxy/bind_port",
  :display_name => "Bind Port",
  :description => "Port that haproxy should bind to",
  :required => false,
  :default => "85"

attribute "lb_haproxy/stats_uri",
  :display_name => "Status URI",
  :description => "URI that the load balancer uses to publish its status",
  :required => false,
  :default => "/haproxy-status"

attribute "lb_haproxy/stats_user",
  :display_name => "Status Page Username",
  :description => "Username required to access to the haproxy stats page",
  :required => false,
  :default => ""

attribute "lb_haproxy/stats_password",
  :display_name => "Status Page Password",
  :description => "Password required to access to the haproxy stats page",
  :required => false,
  :default => ""

attribute "lb_haproxy/health_check_uri",
  :display_name => "Health Check URI",
  :description => " URI for the load balancer to use to check the health of a server (only used when using http templates)",
  :required => false,
  :default => ""

