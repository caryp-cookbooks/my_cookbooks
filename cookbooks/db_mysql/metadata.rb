maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          IO.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'LICENSE')))
description      "Installs/configures a MySQL database server with automated backups"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

depends "mysql", "= 0.9"
depends "rs_tools"
depends "bd_lvmros"
depends "db_mysql"  # RightScale public cookbook

recipe "db_mysql::default", "Installs dbtools"
recipe "db_mysql::do_backup", "Perform backup of MySQL database"
recipe "db_mysql::do_restore_and_become_master", "Restore MySQL database.  Tag as Master.  Set Master DNS.  Kick off a fresh backup from this master."
recipe "db_mysql::do_restore", "Restore MySQL database"  
recipe "db_mysql::do_init_slave", "Initialize MySQL Slave"
recipe "db_mysql::do_tag_as_master", "USE WITH CAUTION! Tag server with master tags and set master DNS to this server."
recipe "db_mysql::do_lookup_master", "Use tags to lookup current master and save in the node"
recipe "db_mysql::do_promote_to_master", "Promote a replicating slave to master"
recipe "db_mysql::setup_master_backup", "Set up crontab MySQL backup job with the master frequency and rotation."
recipe "db_mysql::setup_slave_backup", "Set up crontab MySQL backup job with the slave frequency and rotation."
recipe "db_mysql::do_enable_backup", "Enable crontab MySQL backups (detects master vs. slave automatically)"
recipe "db_mysql::do_disable_backup", "Disable crontab MySQL backups (detects master vs. slave automatically)"
recipe "db_mysql::setup_master_dns", "USE WITH CAUTION! Set master DNS to this server's IP"
recipe "db_mysql::setup_replication_privileges", "Set up privileges for MySQL replication slaves."

# db
attribute "db",
  :display_name => "General Database Options",
  :type => "hash"
  
attribute "db/admin/user",
  :display_name => "Database Admin Username",
  :description => "The username of the database user that has 'admin' privileges.",
  :required => true,
  :recipes => [ "db_mysql::do_restore", "db_mysql::do_promote_to_master","db_mysql::do_restore_and_become_master", "db_mysql::do_backup" ]

attribute "db/admin/password",
  :display_name => "Database Admin Password",
  :description => "The password of the database user that has 'admin' privileges.",
  :required => true,
  :recipes => [ "db_mysql::do_restore", "db_mysql::do_promote_to_master","db_mysql::do_restore_and_become_master", "db_mysql::do_backup" ]
  
attribute "db/replication/user",
  :display_name => "Replication Username",
  :description => "The username that's used for replication between the master and slave databases.",
  :required => true,
  :recipes => [ "db_mysql::do_restore", "db_mysql::do_init_slave", "db_mysql::do_promote_to_master","db_mysql::do_restore_and_become_master", "db_mysql::setup_replication_privileges" ]

attribute "db/replication/password",
  :display_name => "Replication Password",
  :description => "The password that's used for replication between the master and slave databases.",
  :required => true,
  :recipes => [ "db_mysql::do_restore", "db_mysql::do_init_slave", "db_mysql::do_promote_to_master","db_mysql::do_restore_and_become_master", "db_mysql::setup_replication_privileges" ]
  
# dns 
attribute "dns",
  :display_name => "Database DNS Options",
  :type => "hash"
  
attribute "dns/master_id",
  :display_name => "Master DNS ID",
  :description => "This input is used to update the DNSMadeEasy 'A' record's IP address to  point to the new IP address of this server.  Provide the DDNS ID of the 'A' record you wish to be modified.  DNS is only used by application servers to find the master database, it is not required for internal operations. This 7-digit number is provided by DNSMadeEasy. This record should point to the fully qualified domain name of the server's Elastic IP.  Ex: 4404922",
  :required => true,
  :recipes => ["db_mysql::setup_master_dns", "db_mysql::do_restore_and_become_master", "db_mysql::do_promote_to_master", "db_mysql::do_tag_as_master"]

attribute "dns/user",
  :display_name => "DNSMadeEasy Username",
  :description => "The username of your DNSMadeEasy account.",
  :required => true,
  :recipes => ["db_mysql::setup_master_dns", "db_mysql::do_restore_and_become_master", "db_mysql::do_promote_to_master", "db_mysql::do_tag_as_master"]

attribute "dns/password",
  :display_name => "DNSMadeEasy Password",
  :description => "The password of your DNSMadeEasy account.",
  :required => true,
  :recipes => ["db_mysql::setup_master_dns", "db_mysql::do_restore_and_become_master", "db_mysql::do_promote_to_master", "db_mysql::do_tag_as_master"]

# backup 
attribute "db/backup",
  :display_name => "Database Backup Options",
  :type => "hash"  
  
attribute "db/backup/lineage",
  :display_name => "Backup Lineage",
  :description => "The prefix that will be used to name the EBS snapshots of your MySQL database backups.  For example, if prefix is 'mydb' the filename will be 'mydb-master-date/time stamp' for a snapshot of your master database and 'mydb-slave-date/time stamp' for a slave.  During a restore, it will use the most recent MySQL EBS snapshot with the same prefix.",
  :required => true,
  :recipes => [ "db_mysql::do_restore", "db_mysql::do_backup", "db_mysql::do_init_slave","db_mysql::do_restore_and_become_master" ]

attribute "db/backup/master/hour",
  :display_name => "Master Backup Cron Hour",
  :description => "Defines the hour of the day when the backup EBS snapshot will be taken of the Master database.  Backups of the Master are taken daily.  By default, an hour will be randomly chosen at launch time.  The time of the backup is defined by 'Master Backup Cron Hour' and 'Master Backup Cron Minute'.  Uses standard crontab format. (Ex: 23) for 11pm.",
  :required => false,
  :recipes => [ "db_mysql::setup_slave_backup", "db_mysql::setup_master_backup", "db_mysql::do_disable_backup", "db_mysql::do_enable_backup" ]

attribute "db/backup/slave/hour",
  :display_name => "Slave Backup Cron Hour",
  :description => "By default, backup EBS Snapshots of the Slave database are taken hourly. (Ex: *)",
  :required => false,
  :recipes => [ "db_mysql::setup_slave_backup", "db_mysql::setup_master_backup", "db_mysql::do_disable_backup", "db_mysql::do_enable_backup" ]

attribute "db/backup/master/minute",
  :display_name => "Master Backup Cron Minute",
  :description => "Defines the minute of the hour when the backup EBS snapshot will be taken of the Master database.  Backups of the Master are taken daily.  By default, a minute will be randomly chosen at launch time.  The time of the backup is defined by 'Master Backup Cron Hour' and 'Master Backup Cron Minute'.  Uses standard crontab format. (Ex: 30) for the 30th minute of the hour.",
  :required => false,
  :recipes => [ "db_mysql::setup_slave_backup", "db_mysql::setup_master_backup", "db_mysql::do_disable_backup", "db_mysql::do_enable_backup" ]

attribute "db/backup/slave/minute",
  :display_name => "Slave Backup Cron Minute",
  :description => "Defines the minute of the hour when the backup EBS snapshot will be taken of the Slave database.  Backups of the Slave are taken hourly.  By default, a minute will be randomly chosen at launch time.  Uses standard crontab format. (Ex: 30) for the 30th minute of the hour.",
  :required => false,
  :recipes => [ "db_mysql::setup_slave_backup", "db_mysql::setup_master_backup", "db_mysql::do_disable_backup", "db_mysql::do_enable_backup" ]

 attribute "db/backup/lineage_override",
  :display_name => "Backup Lineage Override",
  :description => "If defined, it will override the input defined for 'Backup Lineage'. This input allows you to restore from a different snapshot that has a different prefix than the 'Backup Lineage'; however, the database will continue to backup using the 'Backup Lineage' prefix for subsequent snapshots.  Be sure to remove this input after you bring up the new master.  Ex: myolddb",
  :required => false,
  :recipes => [ "db_mysql::do_restore", "db_mysql::do_backup", "db_mysql::do_init_slave", "db_mysql::do_restore_and_become_master" ]
    
