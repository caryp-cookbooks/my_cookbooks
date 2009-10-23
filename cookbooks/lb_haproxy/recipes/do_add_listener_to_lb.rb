
ruby_block "Tell FE to add new app server" do
  block do
    applistener  = "#{@node[:lb_haproxy][:applistener_name]}"
    backend_name = "#{@node[:lb_haproxy][:backend_name]}"
    port = "8000"
    this_backend = "#{@node[:cloud][:public_ip]}"
    max_conn_per_svr = "#{@node[:lb_haproxy][:max_conn_per_server]}"
    sess_sticky = "#{@node[:lb_haproxy][:session_stickiness]}".downcase
    if(sess_sticky && sess_sticky.match(/^(true|yes|on)$/))
      cookie_options = "-c #{@nodw[:rightscale][:instance_uuid]}"
    end
# /opt/rightscale/lb/bin/haproxy_config_server.rb  -a add -w -l $LB_APPLISTENER -s
# $LB_BACKEND_NAME -t $BACKEND_TARGET -k on -e "inter 3000 rise 2 fall 3 maxconn 3"
    target="#{this_backend}:#{port}"
    args= "-a add -w -l \"#{applistener}\" -s \"#{backend_name}\" -t \"#{target}\" #{cookie_options} -e \" inter 3000 rise 2 fall 3 maxconn #{max_conn_per_svr}\" "
    args += " -k on " if ENV['HEALTH_CHECK_URI'] != nil && ENV['HEALTH_CHECK_URI'] != ""
# Above gets done by the application server making the call.  Sets up the cmd argument string for the unique components supplied by the app server.
# Below is done on the front end.
# It will add in the generic deployment parts (or should the app just create the entire arg string?)
  end
end
ruby_block "FE add listener" do
    cfg_cmd="/opt/rightscale/lb/bin/haproxy_config_server.rb"
    res=`#{cfg_cmd} #{args}`
  end
  :not_if 
  :notify haproxy reload
end
