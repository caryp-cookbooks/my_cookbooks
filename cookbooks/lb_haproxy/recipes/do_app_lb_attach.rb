#
# Cookbook Name:: lb_haproxy
# Recipe:: do_app_lb_attach
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
remote_reicpe "connect me to load ballancer" do
  recipe "lb_haproxy::do_backend_attach"
  attributes :remote_recipe => { 
                :backend_ip => @node[:cloud][:private_ip], 
                :backend_id => @node[:rightscale][:instance_uuid] 
              }
  recipients_tags "rs_loadbal:state=active"
end

