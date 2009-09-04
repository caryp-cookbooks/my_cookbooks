maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures a MySQL database server with automated backups"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

depends "mysql", "= 0.9"
depends "rs_tools"

recipe  "db_mysql::backup", "Backs up the binary DB contents to an EBS snapshot."
recipe  "db_mysql::continuous_backups", "Schedule continuous backups of the database"
recipe  "db_mysql::decommission", "Stop DB, Unmount, detach and delete the current volume mounted for mysql DB"
recipe  "db_mysql::default", "Runs the 'server' and 'continuous_backups' recipes"
recipe  "db_mysql::register_public_ip", "Registers the public IP of the current instance to dns madeeasy."
recipe  "db_mysql::restore_master", "Restores the database from the most recent EBS snapshot and updates DNS to point to the new master."
recipe  "db_mysql::server", "Installs packages required for mysql servers w/o manual intervention"

#
# required attributes
#
attribute "db_mysql/dns",
  :display_name => "General database options",
  :type => "hash"
  
attribute "db_mysql/admin_user",
  :display_name => "Database admin username",
  :description => "The username of the database user that has 'admin' privilages.",
  :required => true

attribute "db_mysql/admin_password",
  :display_name => "Database admin password",
  :description => "The password of the database user that has 'admin' privilages.",
  :required => true
  
attribute "db_mysql/replication_user",
  :display_name => "Replication username",
  :description => "The username that's used for replication between master and slave databases.",
  :required => true

attribute "db_mysql/replication_password",
  :display_name => "Replication Password",
  :description => "The password that's used for replication between master and slave databases.",
  :required => true
  
# dns 
attribute "db_mysql/dns",
  :display_name => "Database DNS options",
  :type => "hash"
  
attribute "db_mysql/dns/master_name",
  :display_name => "Master DNS name",
  :description => "This DNS name is the FNDQ MySQL Master used by the slave and application to connect to the MySQL server",
  :required => true

attribute "db_mysql/dns/master_id",
  :display_name => "External DNS ID",
  :description => "The record ID (or DNS ID) of the server is used to update the DNS record to point to the new server IP address. This 7-digit number is provided by DNSMadeEasy. This record should point to the fully qualified domain name of the servers EIP.  Ex: 4404922",
  :required => true

attribute "db_mysql/dns/user",
  :display_name => "DNSMadeEasy username",
  :description => "The username of your DNSMadeEasy account.",
  :required => true

attribute "db_mysql/dns/password",
  :display_name => "DNSMadeEasy password",
  :description => "The password of your DNSMadeEasy account.",
  :required => true

# backup 
attribute "db_mysql/backup",
  :display_name => "Database backup options",
  :type => "hash"  
  
attribute "db_mysql/backup/prefix",
  :display_name => "Backup prefix",
  :description => "The prefix that will be used to name the EBS snapshots of your MySQL database backups.  For example, if prefix is 'mydb' the filename will be 'mydb-master-date/time stamp' for a snapshot of your master database and 'mydb-slave-date/time stamp' for a slave.  During a restore, it will use the most recent MySQL EBS snapshot with the same prefix.",
  :required => true

#
# recommended
#
attribute "db_mysql/server_usage",
  :display_name => "Server Usage",
  :description => "* dedicated (where the mysql config allocates all existing resources of the machine)\n* shared (where the mysql is configured to use less resources so that it can be run concurrently with other apps like apache and rails for example)",
  :default => "dedicated"

# backup  
attribute "db_mysql/backup/prefix_override",
  :display_name => "Backup prfix override",
  :description => "Override prefix to restore from a specific snapshot.",
  :default => ""

attribute "db_mysql/backup/maximum_snapshots",
  :display_name => "Maximum snapshots",
  :description => "The total number of snapshots to keep. The oldest snapshot will be deleted when this is exceeded.",
  :default => "60"
 
attribute "db_mysql/backup/keep_daily",
  :display_name => "Daily backup count",
  :description => "The number of daily snapshots to keep (i.e. rotation size). See 'Archiving Snapshots' on RightScale Support for further details on the archiving logic.",
  :default => "14"
  
attribute "db_mysql/backup/keep_weekly",
  :display_name => "Weekly backup count",
  :description => "The number of weekly snapshots to keep (i.e. rotation size). See 'Archiving Snapshots' on RightScale Support for further details on the archiving logic.",
  :default => "6"

attribute "db_mysql/backup/keep_monthly",
  :display_name => "Monthly backup count",
  :description => "The number of monthly snapshots to keep (i.e. rotation size). See 'Archiving Snapshots' on RightScale Support for further details on the archiving logic.",
  :default => "12"

attribute "db_mysql/backup/keep_yearly",
  :display_name => "Yearly backup count",
  :description => "The number of yearly snapshots to keep (i.e. rotation size). See 'Archiving Snapshots' on RightScale Support for further details on the archiving logic.",
  :default => "2"

#
# optional
#
attribute "db_mysql/dns_ttl_limit",
  :display_name => "Maximum allowable DNS TTL limit",
  :description => "Verification that master database DNS TTL is low enough",
  :recipes => ["db_mysql::default"],
  :default => "120"

attribute "db_mysql/log_bin",
  :display_name => "Maximum allowable DNS TTL limit",
  :description => "Defines the filename and location of your MySQL stored binlog files.  This sets the log-bin variable in MySQL config file.  If you do not specify an absolute path, it will be relative to the data directory.",
  :default => "/mnt/mysql-binlogs/mysql-bin"
  
attribute "db_mysql/datadir_relocate",
  :display_name => "MySQL data-directory destination",
  :description => "This sets final destination of the MySQL data directory. (i.e. an LVM or EBS volume)",
  :default => "/mnt/mysql"

attribute "db_mysql/tmpdir",
  :display_name => "MySQL tmp directory",
  :description => "This sets the tmp variable in MySQL config file.",
  :default => "/tmp"
  