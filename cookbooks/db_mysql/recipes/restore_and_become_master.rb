# Copyright (c) 2008-2009 RightScale, Inc, All Rights Reserved Worldwide.

# hacktastic!
db_prefix_name= "#{@node[:db_mysql][:backup][:prefix]}"
db_backup_keep_last = "#{@node[:db_mysql][:backup][:maximum_snapshots][:master]}"
ebsdev=`mount | grep /mnt/mysql | awk '{FS=" "; print $1 "  /mnt/mysql xfs defaults 0 0"}'`

ruby "do legacy restore" do
  
  code <<-EOH
    require 'rubygems'
    require 'mysql'

    # Ensure the admin credentials are passed in the environment for the script to administer the DB
    # ENV['DBADMIN_USER']           -- MySQL manager credential: admin db user
    # ENV['DBADMIN_PASSWORD']       -- MySQL manager credential: admin db password
    ENV['DBADMIN_USER']="#{@node[:db_mysql][:admin_user]}"
    ENV['DBADMIN_PASSWORD']="#{@node[:db_mysql][:admin_password]}"

    # Ensure the replication credentials are passed in the environment for the script to use them
    # ENV['DBREPLICATION_USER']     -- MySQL manager credential: replication user
    # ENV['DBREPLICATION_PASSWORD'] -- MySQL manager credential: replication user password
    ENV['DBREPLICATION_USER']="#{@node[:db_mysql][:replication_user]}"
    ENV['DBREPLICATION_PASSWORD']="#{@node[:db_mysql][:replication_password]}"

    # We also need the API path (from user data) and the instance id (from meta-data). 
    # Although these are set automatically for us.
    ENV['RS_API_URL']="#{@node[:rightscale][:api_url]}"
    ENV['RS_DISTRO']="#{@node[:platform]}"
    ENV['EC2_INSTANCE_ID'] = "#{@node[:ec2][:instance_id]}"

    #puts "DB name of the DB to be restore has been overridden with 'DB_RESTORE_OVERRIDE'=#{ENV['DB_RESTORE_PREFIX_OVERRIDE']}"
    #db_prefix_name= ( ENV['DB_RESTORE_PREFIX_OVERRIDE']  ? ENV['DB_RESTORE_PREFIX_OVERRIDE'] : ENV['DB_EBS_PREFIX'] )
    
    puts "DB PREFIX to restore: #{db_prefix_name}"
    puts `/opt/rightscale/db/ec2_ebs/restoreDB.rb -n #{db_prefix_name} `
    exit(-1) if $? != 0

    # Ensure admin credentials match our inputs..
    con = Mysql.new("", "root" )
    con.query("GRANT ALL PRIVILEGES on *.* TO '#{@node[:db_mysql][:admin_user]}'@'%' IDENTIFIED BY '#{@node[:db_mysql][:admin_password]}' WITH GRANT OPTION")
    con.query("GRANT ALL PRIVILEGES on *.* TO '#{@node[:db_mysql][:admin_user]}'@'localhost' IDENTIFIED BY '#{@node[:db_mysql][:admin_password]}' WITH GRANT OPTION")
    con.query("FLUSH PRIVILEGES")
    con.close

    # DNS made easy credentials (used as environment variables by the script)
    # ENV['DNSMADEEASY_USER']       -- dnsmadeeasy credentials: username
    # ENV['DNSMADEEASY_PASSWORD']   -- dnsmadeeasy credentials: password
    ENV['DNSMADEEASY_USER'] = "#{@node[:db_mysql][:dns][:user]}"
    ENV['DNSMADEEASY_PASSWORD'] = "#{@node[:db_mysql][:dns][:password]}"
    
    puts "Configuring DNS for ID: #{@node[:db_mysql][:dns][:master_id]}"
    10.times {puts `/opt/rightscale/dns/dnsmadeeasy_set.rb -i #{@node[:db_mysql][:dns][:master_id]}`;break if $? == 0;sleep 1} 
    (puts "Could not update DNS for ID: #{@node[:db_mysql][:dns][:master_id]}\nExiting!!!";exit(1)) unless $? == 0


    if "#{@node[:platform]}" == "ubuntu"
    # Need to wait for MySQL to finish the db check..
      sleep 10
      while `echo "show processlist;" | mysql` =~ /FAST/
        puts "wating for MySQL to complete db check..."
        sleep 30
      end
    end

    system("logger -t RightScale Database restored from backups.")

    puts "Adding /etc/fstab entry for /mnt/mysql"    
    puts "Adding #{ebsdev}"
    `echo "" >> /etc/fstab`
    puts `echo "#{ebsdev}" >> /etc/fstab`

    # Kick-off a master backup from this server, so a slave can potentially initialize quickly 
    # (i.e., as soon as this backup is completed). NOTE we're forcing a backup as the master (since we 
    # cannot rely on the DNS to have changed this quickly yet)
    puts "Kickstarting a master backup..."
    puts `/usr/local/bin/mysql-binary-backup.rb --as-master --max-snapshots #{db_backup_keep_last} 2>&1`
    puts "backup completed"
  EOH
end
