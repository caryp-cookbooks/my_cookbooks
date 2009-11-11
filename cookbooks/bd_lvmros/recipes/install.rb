#
# Cookbook Name:: lvm
# Recipe:: install
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
package "lvm2"
package "xfsprogs"

# package "kmod-xfs"  #centos?

ruby_block "Load kernel modules" do
  block do
    `modprobe dm_mod`
    `modprobe dm_snapshot`
    `modprobe xfs`
  end
end

