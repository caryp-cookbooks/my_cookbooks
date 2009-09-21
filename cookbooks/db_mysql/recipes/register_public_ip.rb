# Cookbook Name:: db_mysql
# Recipe:: register_public_ip
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

# configure master DB DNS record 
ruby do
  code <<-EOH
  puts "user: #{@node[:db_mysql][:dns][:user]}"
  puts "password: #{@node[:db_mysql][:dns][:password]}"
  EOH
end
dns @node[:db_mysql][:dns][:master_id] do
  user "#{@node[:db_mysql][:dns][:user]}"
  passwd "#{@node[:db_mysql][:dns][:password]}"
  ip_address @node[:cloud][:public_ip]
end

