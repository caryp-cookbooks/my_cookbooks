# Cookbook Name:: db_mysql
# Recipe:: do_register_public_ip
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

# configure master DB DNS record with public ip address
dns @node[:db_mysql][:dns][:master_id] do
  user "#{@node[:dns][:user]}"
  passwd "#{@node[:dns][:password]}"
  ip_address @node[:cloud][:public_ip][0]
end

