#
# Cookbook Name:: db_mysql
# Recipe:: do_tag_as_master
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
#
# Important: This recipe sets master tags AND the DNS_ID of the master server.  Use with caution!

active_tag = "rs_dbrepl:master_active=#{Time.now.strftime("%Y%m%d%H%M%S")}"
Chef::Log.info "Tagging server with #{active_tag}"
right_link_tag active_tag

unique_tag = "rs_dbrepl:master_instance_uuid=#{node[:rightscale][:instance_uuid]}"
Chef::Log.info "Tagging server with #{unique_tag}"
right_link_tag unique_tag

include_recipe "db_mysql::setup_master_dns"
