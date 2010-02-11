# Cookbook Name:: db_mysql
# Recipe:: setup_replication_privileges
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

database "localhost" do
  not_if do false end # http://tickets.opscode.com/browse/CHEF-894
  action :grant_replication_slave
end
