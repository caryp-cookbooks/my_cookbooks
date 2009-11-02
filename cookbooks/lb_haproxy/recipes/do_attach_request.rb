#
# Cookbook Name:: lb_haproxy
# Recipe:: do_attach_request
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
remote_recipe "Attach me to load ballancer" do
  recipe "lb_haproxy::do_attach"
  attributes :remote_recipe => { 
                :backend_ip => @node[:cloud][:private_ip][0], 
                :backend_id => @node[:rightscale][:instance_uuid] 
              }
  recipients_tags "rs_loadbal:state=active"
end

