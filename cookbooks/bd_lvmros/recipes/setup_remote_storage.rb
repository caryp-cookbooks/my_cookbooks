#
# Cookbook Name:: bd_lvmros
# Recipe:: setup_remote_storage
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

# Setup all remote_storage resources that have attributes in the node.
node[:remote_storage].each do | resource_name, ros| 
  
    # Setup cloud storage and create container (if it doesn't exist)
    remote_storage resource_name do
      user ros[:account][:id]
      key ros[:account][:credentials]
      container ros[:container]
      provider_type ros[:provider]
      action :create_container
    end

end