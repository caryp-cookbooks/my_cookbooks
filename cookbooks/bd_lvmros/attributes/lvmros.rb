# Cookbook Name:: bd_lvmros
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

class Chef::Node
  include RightScale::BlockDevice::EC2
end

set_unless[:lvmros][:default][:remote_storage_resource] = "default" # currently hard-coded
set_unless[:lvmros][:default][:backup][:compress] = true
set_unless[:lvmros][:default][:backup][:parallelism] = "3"
set_unless[:lvmros][:default][:mount_point] = "/mnt"
set_unless[:lvmros][:default][:fs][:type] = "xfs"
set_unless[:lvmros][:default][:fs][:options] = "-f"

#
# Platform specific attributes
#
if cloud
  case cloud[:provider]
  when "ec2"
    set_unless[:lvmros][:default][:device_list] = ephemeral_devices
  when "rackspace"
    set_unless[:lvmros][:default][:device_list] = [ '/dev/mapper/lvmbase' ]
    set_unless[:lvmros][:default][:fs][:type] = "ext3"
    set_unless[:lvmros][:default][:fs][:options] = ""
  when "gogrid"
    set_unless[:lvmros][:default][:device_list] = [ '/dev/hda4' ]
  else 
		raise "ERROR: Unknown cloud provider"
  end
end


