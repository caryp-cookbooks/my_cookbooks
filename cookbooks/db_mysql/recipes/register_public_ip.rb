# Cookbook Name:: db_mysql
# Recipe:: register_public_ip
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

# configure master DB DNS record 
ruby "Output dns vars" do
  code <<-EOH
  user = "#{@node[:dns][:user]}"
  pass = "#{@node[:dns][:password]}"

  puts "user: \#{user}"
  puts "password: \#{pass}"
  EOH
end
dns @node[:db_mysql][:dns][:master_id] do
  user "#{@node[:dns][:user]}"
  passwd "#{@node[:dns][:password]}"
  ip_address @node[:cloud][:public_ip]
end

