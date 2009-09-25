# Cookbook Name:: db_mysql
# Recipe:: do_ddns_check
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

# throw an error of the DNS TTL is too high
bash "check dynamic dns ttl" do
  user "root"
  code <<-EOH
    set -xe
    dnsttl=`dig #{@node[:db_mysql][:dns][:master_name]} | grep ^#{@node[:db_mysql][:dns][:master_name]}| awk '{ print $2}'`
   if [ $dnsttl -gt #{@node[:db_mysql][:dns][:ttl_limit]} ]; then
   logger -t RightScale "Master DB DNS TTL set too high.  Must be set <= #{@node[:db_mysql][:dns][:ttl_limit]}" 
     exit 1
   fi
   logger -t RightScale "Master DB DNS TTL: $dnsttl"
  EOH
end