maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          IO.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'LICENSE')))
description      "Installs/configures a MySQL database server with automated backups"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

depends "mysql", "= 0.9"
depends "rs_tools"
depends "db_mysql"  # RightScale public cookbook
 
provides "db_mysql_restore(url, branch, user, credentials, file_path, schema_name, tmp_dir)"
provides "db_mysql_set_privileges(type, username, password)"

recipe  "db_mysql::default", "Runs the 'server' and 'continuous_backups' recipes."
recipe  "db_mysql::do_backup", "Backs up the binary DB contents to an EBS snapshot."
recipe  "db_mysql::setup_continuous_backups", "Schedule continuous backups of the database."
recipe  "db_mysql::do_ddns_check", "Throw an error if the DNS TTL is too high."
recipe  "db_mysql::decommission", "Stop DB, unmount, detach, and delete the current volume that was mounted for the MySQL database."
recipe  "db_mysql::do_register_public_ip", "Registers the public IP of the current instance to DNSMadeEasy."
recipe  "db_mysql::do_restore_master", "Restores the database from the most recent EBS snapshot and updates DNS to point to the new master."

#
# required attributes
#
attribute "db_mysql",
  :display_name => "General Database Options",
  :type => "hash"
  
attribute "db_mysql/admin_user",
  :display_name => "Database Admin Username",
  :description => "The username of the database user that has 'admin' privileges.",
  :required => true

attribute "db_mysql/admin_password",
  :display_name => "Database Admin Password",
  :description => "The password of the database user that has 'admin' privileges.",
  :required => true
  
attribute "db_mysql/replication_user",
  :display_name => "Replication Username",
  :description => "The username that's used for replication between the master and slave databases.",
  :required => true

attribute "db_mysql/replication_password",
  :display_name => "Replication Password",
  :description => "The password that's used for replication between the master and slave databases.",
  :required => true
  
# dns 
attribute "db_mysql/dns",
  :display_name => "Database DNS Options",
  :type => "hash"
  
attribute "db_mysql/dns/master_name",
  :display_name => "Master DNS Name",
  :description => "This DNS name is the FNDQ MySQL Master used by the slave and application to connect to the MySQL server.",
  :recipes => ["db_mysql::setup_continuous_backups", "db_mysql::do_ddns_check"],
  :required => true

attribute "db_mysql/dns/master_id",
  :display_name => "Master DNS ID",
  :description => "The record ID (or DNS ID) of the server is used to update the DNS record to point to the new server IP address. This 7-digit number is provided by DNSMadeEasy. This record should point to the fully qualified domain name of the server's Elastic IP.  Ex: 4404922",
  :required => true

attribute "dns/user",
  :display_name => "DNSMadeEasy Username",
  :description => "The username of your DNSMadeEasy account.",
  :required => true

attribute "dns/password",
  :display_name => "DNSMadeEasy Password",
  :description => "The password of your DNSMadeEasy account.",
  :required => true

# backup 
attribute "db_mysql/backup",
  :display_name => "Database Backup Options",
  :type => "hash"  
  
attribute "db_mysql/backup/prefix",
  :display_name => "Backup Prefix",
  :description => "The prefix that will be used to name the EBS snapshots of your MySQL database backups.  For example, if prefix is 'mydb' the filename will be 'mydb-master-date/time stamp' for a snapshot of your master database and 'mydb-slave-date/time stamp' for a slave.  During a restore, it will use the most recent MySQL EBS snapshot with the same prefix.",
  :required => true

#
# recommended attributes
#
attribute "db_mysql/server_usage",
  :display_name => "Server Usage",
  :description => "* dedicated (where the mysql config file allocates all existing resources of the machine)\n* shared (where the mysql config file is configured to use less resources so that it can be run concurrently with other apps like apache and rails for example)",
  :default => "dedicated"

# backup  
attribute "db_mysql/backup/keep_minimum",
  :display_name => "Minimum Backup Count",
  :description => "The minimum number of snapshots to keep. The oldest snapshot will be deleted when this is exceeded. This is overrides of the Daily, Weekly, etc. backup count.  Typically set to the total number of backups made in a day.",
  :default => "60"
 
attribute "db_mysql/backup/keep_daily",
  :display_name => "Daily Backup Count",
  :description => "The number of daily snapshots to keep (i.e. rotation size). See 'Archiving Snapshots' on RightScale Support for further details on the archiving logic.",
  :default => "14"
  
attribute "db_mysql/backup/keep_weekly",
  :display_name => "Weekly Backup Count",
  :description => "The number of weekly snapshots to keep (i.e. rotation size). See 'Archiving Snapshots' on RightScale Support for further details on the archiving logic.",
  :default => "6"

attribute "db_mysql/backup/keep_monthly",
  :display_name => "Monthly Backup Count",
  :description => "The number of monthly snapshots to keep (i.e. rotation size). See 'Archiving Snapshots' on RightScale Support for further details on the archiving logic.",
  :default => "12"

attribute "db_mysql/backup/keep_yearly",
  :display_name => "Yearly Backup Count",
  :description => "The number of yearly snapshots to keep (i.e. rotation size). See 'Archiving Snapshots' on RightScale Support for further details on the archiving logic.",
  :default => "2"

#
# optional attributes
#
attribute "db_mysql/dns/ttl_limit",
  :display_name => "Maximum DNS Time-To-Live",
  :description => "Verification that master database DNS TTL is low enough. WARNING: can produce false positives.",
  :recipes => ["db_mysql::do_ddns_check"],
  :default => "120"

attribute "db_mysql/log_bin",
  :display_name => "MySQL Binlog Destination",
  :description => "Defines the filename and location of your MySQL stored binlog files.  This sets the log-bin variable in the MySQL config file.  If you do not specify an absolute path, it will be relative to the data directory.",
  :default => "/mnt/mysql-binlogs/mysql-bin"
  
attribute "db_mysql/datadir_relocate",
  :display_name => "MySQL Data-Directory Destination",
  :description => "Sets the final destination of the MySQL data directory. (i.e. an LVM or EBS volume)",
  :default => "/mnt/mysql"

attribute "db_mysql/tmpdir",
  :display_name => "MySQL Tmp Directory",
  :description => "Sets the tmp variable in the MySQL config file.",
  :default => "/tmp"
 
 attribute "db_mysql/backup/prefix_override",
  :display_name => "Backup Prefix Override",
  :description => "If this parameter is specified, this value will be used to determine which snapshot to load, but backups will still be taken with the db_mysql/backup/prefix value."
  :required => false

 
