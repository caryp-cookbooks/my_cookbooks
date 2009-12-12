active_tag = "db:master_active=#{Time.now.strftime("%Y%m%d%H%M%S")}"
Chef::Log.info "Tagging server with #{active_tag}"
right_link_tag active_tag

unique_tag = "db:master_instance_uuid=#{node[:rightscale][:instance_uuid]}"
Chef::Log.info "Tagging server with #{unique_tag}"
right_link_tag unique_tag
