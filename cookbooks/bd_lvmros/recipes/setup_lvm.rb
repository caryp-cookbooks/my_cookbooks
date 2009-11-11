#
# Cookbook Name:: bd_lvmros
# Recipe:: setup_lvm
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

# Setup all lvmros resources that have attributes in the node.
node[:lvmros].each do |resource_name, lvm| 
  
    # Setup physical block devices for LVM
    lvm[:device_list].each do |dev_name|
      block_device dev_name do
        device dev_name
        provider_type "local"
        action :create
      end
    end
    
    # Setup LVM with cloud storage
    block_device resource_name do
      mount_point lvm[:mount_point]
      fstype lvm[:fs][:type] 
      format_options lvm[:fs][:options]
      block_device_resources lvm[:device_list]
      remote_storage_resource lvm[:remote_storage_resource]
      provider_type "LVMROS"
      action :create
    end

end