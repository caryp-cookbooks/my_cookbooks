# Cookbook Name:: db_mysql
# Recipe:: do_decommission
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

rs_tools "dbtools-0.18.12.tgz"

ruby "decommision database" do
  environment 'RS_DISTRO' => @node[:platform] 
  code <<-EOH
    require '/opt/rightscale/db/common/d_b_utils.rb'
    require '/opt/rightscale/ebs/ec2_ebs_utils.rb'
    require '/var/spool/ec2/meta-data.rb'
    require '/var/spool/ec2/user-data.rb'

    runlevel=`runlevel`.split(" ")[1].to_i

    puts "Runlevel detected : \#{runlevel}"

    if runlevel!=0
      puts "Machine will be rebooting...skipping the termination of the DB volume..."
      exit 0
    end

    db=RightScale::DBUtils.new(
                        :rep_user => $DBREPLICATION_USER,
                        :rep_pass => $DBREPLICATION_PASSWORD
    )

    ebs=RightScale::Ec2EbsUtils.new(
                        :mount_point => RightScale::DBUtils::DBMountPoint,
                        :rs_api_url => "#{@node[:rightscale_depricated][:api_url]}"
    )

    puts "Machine is terminating...we'll unmount, detach and delete the current DB volume."

    db.db_service_stop(nil)
    puts "Database service stopped"

    vol=ebs.terminate_volume
    puts "Volume \#{vol} terminated."

    puts "EBS volume termination completed successfully"
    exit 0
  EOH
end

