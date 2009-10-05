

#include_recipe "lb_haproxy::tools_install"
#include_recipe "lb_haproxy"
#include_recipe "web_apache"
#include_recipe "lb_haproxy::reverse_proxy_config"
include_recipe "lb_haproxy::app_to_local_HA_proxy"
#include_recipe "lb_haproxy::app_to_HA_proxy_connect"
#include_recipe "lb_haproxy::app_to_HA_proxy_disconnect"
#include_recipe "lb_haproxy::get_HA_proxy_config"

