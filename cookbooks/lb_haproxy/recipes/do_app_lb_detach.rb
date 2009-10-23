#
# Cookbook Name:: lb_haproxy
# Recipe:: do_app_lb_detach
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
remote_reicpe "disconnect me from load ballancer" do
  recipe "lb_haproxy::do_backend_detach"
  attributes :remote_recipe => { 
                :backend_ip => @node[:cloud][:public_ip], 
                :backend_id => @node[:rightscale][:instance_uuid] 
              }
  recipients_tags "rs_loadbal:state=active"
end

