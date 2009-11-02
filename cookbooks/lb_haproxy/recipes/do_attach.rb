#
# Cookbook Name:: lb_haproxy
# Recipe:: do_attach
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
service "haproxy" do
  supports :restart => true, :status => true
  action [ :enable ]
end

ruby_block "add to config, if not in config file" do
  block do
    applistener  = "#{@node[:lb_haproxy][:applistener_name]}"
    backend_name = "#{@node[:remote_recipe][:backend_id]}"
    port = "8000"
    backend_ip = "#{@node[:remote_recipe][:backend_ip]}"
    max_conn_per_svr = "#{@node[:lb_haproxy][:max_conn_per_server]}"
    session_sticky = "#{@node[:lb_haproxy][:session_stickiness]}".downcase
    if(session_sticky && session_sticky.match(/^(true|yes|on)$/))
      cookie_options = "-c #{@node[:remote_recipe][:backend_id]}"
    end
    target="#{backend_ip}:#{port}"
    args= "-a add -w -l \"#{applistener}\" -s \"#{backend_name}\" -t \"#{target}\" #{cookie_options} "
    args += "-e \" inter 3000 rise 2 fall 3 maxconn #{max_conn_per_svr}\" "
    args += " -k on " if "#{@node[:lb_haproxy][:health_check_uri]}" != ""
    cfg_cmd="/opt/rightscale/lb/bin/haproxy_config_server.rb"
    res=`#{cfg_cmd} #{args}`
  end
  notifies :restart, resources(:service => "haproxy"), :immediately
end

service "haproxy" do
  supports :restart => true, :status => true
  action [ :enable, :restart ]
end
