#
# Cookbook Name:: lvm
# Recipe:: default
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

include_recipe "bd_lvmros::install"
include_recipe "bd_lvmros::setup_remote_storage"
include_recipe "bd_lvmros::setup_lvm"
