# Cookbook Name:: db_mysql
# Recipe:: default
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
include_recipe "db_mysql::install_mysql" 
include_recipe "db_mysql::setup_continuous_backups" 
