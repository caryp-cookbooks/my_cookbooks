maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures a MySQL database server with automated backups"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

depends "mysql", "= 0.9"

recipe            "db_mysql::default", "Installs packages required for mysql servers w/o manual intervention"
recipe            "db_mysql::tools_install", "Installs RightScale dbtools package required by other recipes"
recipe            "db_mysql::continuous_backups", "Schedule continuous backups of the database"
recipe            "db_mysql::restore_and_become_master", "Restores the database from the most recent EBS snapshot and updates DNS to point to the new master."
recipe            "db_mysql::backup", "Backs up the binary DB contents to an EBS snapshot."

#
# required
#
attribute "db_mysql/dns/master_name",
  :display_name => "Master DNS name",
  :description => "This DNS name is the FNDQ MySQL Master used by the slave and application to connect to the MySQL server",
  :required => true

attribute "db_mysql/dns/master_id",
  :display_name => "External DNS ID",
  :description => "The record ID (or DNS ID) of the server is used to update the DNS record to point to the new server IP address. This 7-digit number is provided by DNSMadeEasy. This record should point to the fully qualified domain name of the servers EIP.  Ex: 4404922",
  :required => true

attribute "db_mysql/dns/user",
  :display_name => "DNSMadeEasy Username",
  :description => "The username of your DNSMadeEasy account.",
  :required => true

attribute "db_mysql/dns/password",
  :display_name => "DNSMadeEasy Password",
  :description => "The password of your DNSMadeEasy account.",
  :required => true

attribute "db_mysql/backup/prefix",
  :display_name => "Backup Prefix",
  :description => "The prefix that will be used to name the EBS snapshots of your MySQL database backups.  For example, if prefix is 'mydb' the filename will be 'mydb-master-date/time stamp' for a snapshot of your master database and 'mydb-slave-date/time stamp' for a slave.  During a restore, it will use the most recent MySQL EBS snapshot with the same prefix.",
  :required => true

#
# recommended
#
attribute "db_mysql/server_usage",
  :display_name => "Server Usage",
  :description => "* dedicated (where the mysql config allocates all existing resources of the machine)\n* shared (where the mysql is configured to use less resources so that it can be run concurrently with other apps like apache and rails for example)",
  :multiple_values => true,
  :default => [:dedicated, :shared]

attribute "db_mysql/backup/maximum_snapshots",
  :display_name => "Maximum snapshots ",
  :description => "The total number of snapshots to keep. The oldest snapshot will be deleted when this is exceeded.",
  :default => "60"
  
attribute "db_mysql/backup/frequency/master",
  :display_name => "Backup frequency - Master",
  :description => "How often snapshots are taken. Offset the start time by random number of minutes between 5-29",
  :calculated => true
  
attribute "db_mysql/backup/frequency/slave",
  :display_name => "Backup frequency - Slave",
  :description => "How often snapshots are taken. Offset the start time by random number of minutes between 30-59",
  :calculated => true  

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
  