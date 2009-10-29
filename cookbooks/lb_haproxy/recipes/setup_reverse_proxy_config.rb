#
# Cookbook Name:: lb_haproxy
# Recipe:: setup_reverse_proxy_config
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

apache_module "proxy_http"

web_app "rightscale-reverse-proxy.vhost" do
  template "rightscale-reverse-proxy.vhost.erb"
end

