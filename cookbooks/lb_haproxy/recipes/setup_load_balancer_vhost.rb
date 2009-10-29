#
# Cookbook Name:: lb_haproxy
# Recipe:: setup_load_balancer_vhost
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

apache_site "000-default" do
  enable false
end

web_app "http-80-lbhost.vhost" do
  template "http-80-lbhost.vhost.erb"
end

