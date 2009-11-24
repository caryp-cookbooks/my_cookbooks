#
# Cookbook Name:: database_test
# Recipe:: default
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

database "testdb"
  action :lock
end

database "testdb"
  action :unlock
end
