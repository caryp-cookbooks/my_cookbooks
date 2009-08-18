# Copyright (c) 2007-2009 by RightScale Inc., all rights reserved

# Do the backup (ensure we do it if we are either master or slave)

max_snaps = @node[:db_mysql][:backup][:maximum_snapshots]
keep_daily=@node[:db_mysql][:backup][:keep_daily]
keep_weekly=@node[:db_mysql][:backup][:keep_daily]
keep_monthly=@node[:db_mysql][:backup][:keep_daily]
keep_yearly=@node[:db_mysql][:backup][:keep_daily]
backup_options = "--max-snapshots #{max_snaps} -D #{keep_daily} -W #{keep_weekly} -M #{keep_monthly} -Y #{keep_yearly}"

execute "/usr/local/bin/mysql-binary-backup.rb --if-master #{backup_options}"
execute "/usr/local/bin/mysql-binary-backup.rb --if-slave #{backup_options}"

