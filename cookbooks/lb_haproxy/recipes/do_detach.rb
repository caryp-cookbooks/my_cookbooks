#
# Cookbook Name:: lb_haproxy
# Recipe:: do_detach
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

ruby_block "Remove from config, if in config file" do
  block do
    applistener  = "#{@node[:lb_haproxy][:applistener_name]}"
    backend_name = "#{@node[:remote_recipe][:backend_id]}"
    port = "8000"
    backend_ip = "#{@node[:remote_recipe][:backend_ip]}"
    target="#{backend_ip}:#{port}"
    args= "-a del -w -l \"#{applistener}\" -s \"#{backend_name}\" -t \"#{target}\" "
    cfg_cmd="/opt/rightscale/lb/bin/haproxy_config_server.rb"
    res=`#{cfg_cmd} #{args}`
    `service haproxy restart`
  end
end

