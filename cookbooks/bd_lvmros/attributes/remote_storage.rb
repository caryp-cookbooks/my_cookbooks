# Cookbook Name:: bd_lvmros
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

set_unless[:remote_storage][:default][:container] = "remote_storage_container"
set_unless[:remote_storage][:default][:account][:id] = nil
set_unless[:remote_storage][:default][:account][:credentials] = nil

#
# Platform specific attributes
#
# if none specified, CloudFiles is the default backup provider
if cloud  
  case cloud[:provider]
  when "ec2"
    set_unless[:remote_storage][:default][:provider] = "S3"
  else
    set_unless[:remote_storage][:default][:provider] = "CloudFiles"
  end
end
