#
# Cookbook Name:: lb_haproxy
# Recipe:: do_detach_request
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
right_link_tag "loadbalancer:app=#{@node[:lb_haproxy][:applistener_name]}" do
  action :remove
end
remote_recipe "Detach me from load ballancer" do
  recipe "lb_haproxy::do_detach"
  attributes :remote_recipe => { 
                :backend_ip => @node[:cloud][:private_ip][0], 
                :backend_id => @node[:rightscale][:instance_uuid] 
              }
  recipients_tags "loadbalancer:lb=#{@node[:lb_haproxy][:applistener_name]}"
end

