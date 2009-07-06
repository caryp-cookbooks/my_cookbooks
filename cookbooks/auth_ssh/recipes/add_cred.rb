#
# Cookbook Name:: auth_ssh
# Recipe:: add_cred
#
# Copyright 2009, RightScale, Inc
#

auth_ssh_add_cred "add_ssh_cred" do
  user @node[:ssh][:user]
  host @node[:ssh][:host] 
  template @node[:ssh][:template]
  cred @node[:ssh][:cred]
end

