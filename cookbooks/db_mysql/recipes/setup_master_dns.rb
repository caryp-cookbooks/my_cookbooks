#
# Cookbook Name:: db_mysql
# Recipe:: setup_master_dns
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

log "Configuring DNS for ID: #{node[:dns][:master_id]} -> #{node[:cloud][:private_ip][0]}"

# configure master DB DNS record 
dns node[:dns][:master_id] do
  user node[:dns][:user]
  passwd node[:dns][:password]
  ip_address node[:cloud][:private_ip][0]
end
