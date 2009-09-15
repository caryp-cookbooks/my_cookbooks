# Cookbook Name:: db_mysql
# Recipe:: restore_master
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

rs_tools "dbtools-0.18.12.tgz"

# restore the db from EBS volume. Override prefix to restore from a specific snapshot.
ruby "do dbtool EBS restore" do
  environment 'DBREPLICATION_USER' => @node[:db_mysql][:replication_user], 'DBREPLICATION_PASSWORD' => @node[:db_mysql][:replication_password], 'RS_API_URL' => @node[:rightscale][:api_url], 'RS_DISTRO' => @node[:platform], 'EC2_INSTANCE_ID' => @node[:ec2][:instance_id]  
  code <<-EOH
  # if "#{@node[:db_mysql][:backup][:prefix_override]}" == "" then
      db_prefix_name = "#{@node[:db_mysql][:backup][:prefix]}"    
  #  else
  #    puts "DB name of the DB to be restore has been overridden with 'prefix_override'=#{@node[:db_mysql][:backup][:prefix_override]}"
  #    db_prefix_name = "#{@node[:db_mysql][:backup][:prefix_override]}"   
  #  end
    puts "DB PREFIX to restore: \#{db_prefix_name}"
    puts `/opt/rightscale/db/ec2_ebs/restoreDB.rb -n \#{db_prefix_name}`
    exit(-1) if $? != 0
  EOH
end

include_recipe "db_mysql::setup_admin_privileges"

# configure master DB DNS record 
dns @node[:db_mysql][:dns][:master_id] do
  user @node[:db_mysql][:dns][:user]
  passwd @node[:db_mysql][:dns][:password]
  ip_address @node[:cloud][:private_ip]
end

ruby "wait for db" do
  code <<-EOH
    if "#{@node[:platform]}" == "ubuntu"
      puts "Need to wait for MySQL to finish the db check.."
      sleep 10
      while `echo "show processlist;" | mysql` =~ /FAST/
        puts "wating for MySQL to complete db check..."
        sleep 30
      end
    end
    system("logger -t RightScale Database restored from backups.")
  EOH
end

ruby "add fstab entry for EBS volume" do
  code <<-EOH
    puts "Adding /etc/fstab entry for /mnt/mysql"    
    puts "Adding " + `mount | grep /mnt/mysql | awk '{FS=" "; print $1 "  /mnt/mysql xfs defaults 0 0"}'`
    `echo "" >> /etc/fstab`
    `mount | grep /mnt/mysql | awk '{FS=" "; print $1 "  /mnt/mysql xfs defaults 0 0"}' >> /etc/fstab`
  EOH
end

# Kick-off a master backup from this server, so a slave can potentially initialize quickly 
# (i.e., as soon as this backup is completed). NOTE we're forcing a backup as the master (since we 
# cannot rely on the DNS to have changed this quickly yet)
ruby "add fstab entry for EBS volume" do
  environment 'RS_DISTRO' => @node[:platform]
  code <<-EOH   
    puts "Kickstarting a master backup..."
    puts `/usr/local/bin/mysql-binary-backup.rb --as-master --max-snapshots #{@node[:db_mysql][:backup][:maximum_snapshots]} 2>&1`
    puts "backup completed"
  EOH
end
