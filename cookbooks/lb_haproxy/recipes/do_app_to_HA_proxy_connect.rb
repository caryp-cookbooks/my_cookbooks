remote_file "/tmp/hacky_script" do
  source "lb_app_to_haproxy_connect"
  mode "0744"
end

bash "get_inputs" do
  user "root"
  cwd "/tmp"
  code <<-EOH 

cat << EOF > /tmp/hacky_script_inputs
export HEALTH_CHECK_URI="#{@node[:lb_haproxy][:health_check_uri]}"
export LB_APPLISTENER_NAME="#{@node[:lb_haproxy][:applistener_name]}"
export LB_BACKEND_NAME="#{@node[:lb_haproxy][:backend_name]}"
export LB_HOSTNAME="#{@node[:lb_haproxy][:host]}"
export MAX_CONN_PER_SERVER="#{@node[:lb_haproxy][:max_conn_per_server]}"
export OPT_SESSION_STICKINESS="#{@node[:lb_haproxy][:session_stickiness]}"
export OPT_VHOST_PORT="8000"
export EC2_LOCAL_IPV4="#{@node[:cloud][:public_ip]}"

EOF

  EOH
end

bash "connect_app_to_haproxy" do



  user "root"
  cwd "/tmp"
  code <<-EOH 
export HEALTH_CHECK_URI="#{@node[:lb_haproxy][:health_check_uri]}"
export LB_APPLISTENER_NAME="#{@node[:lb_haproxy][:applistener_name]}"
export LB_BACKEND_NAME="#{@node[:lb_haproxy][:backend_name]}"
export LB_HOSTNAME="#{@node[:lb_haproxy][:host]}"
export MAX_CONN_PER_SERVER="#{@node[:lb_haproxy][:max_conn_per_server]}"
export OPT_SESSION_STICKINESS="#{@node[:lb_haproxy][:session_stickiness]}"
export OPT_VHOST_PORT="8000"
export EC2_LOCAL_IPV4="#{@node[:cloud][:public_ip]}"

/tmp/hacky_script >  /tmp/hacky_script_output
EOH
end

