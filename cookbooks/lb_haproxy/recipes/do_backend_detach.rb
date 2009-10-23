#
# Cookbook Name:: lb_haproxy
# Recipe:: do_backend_attach
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
ruby_block "add to config, if not in config file" do
  only_if `grep -q #{@node[:remote_recipe][:appserver_ip]} #{@node[:lb_haproxy][:cfg_file]}`
  block do
    applistener  = "#{@node[:lb_haproxy][:applistener_name]}"
    backend_name = "#{@node[:lb_haproxy][:backend_name]}"
    port = "8000"
    backend_ip = "#{@node[:remote_recipe][:appserver_ip]}"
    max_conn_per_svr = "#{@node[:lb_haproxy][:max_conn_per_server]}"
    sess_sticky = "#{@node[:lb_haproxy][:session_stickiness]}".downcase
    if(sess_sticky && sess_sticky.match(/^(true|yes|on)$/))
      cookie_options = "-c #{@node[:remote_recipe][:backend_id]}"
    end
    target="#{backend_ip}:#{port}"
    args= "-a del -w -l \"#{applistener}\" -s \"#{backend_name}\" -t \"#{target}\" "
    cfg_cmd="/opt/rightscale/lb/bin/haproxy_config_server.rb"
    res=`#{cfg_cmd} #{args}`
  end
  notifies :reload, resources(:service => "haproxy") 
end
