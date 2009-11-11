# restore
include_recipe "db_mysql::do_restore"
# tag this instance as a master instance
include_recipe "db_mysql::do_tag_as_master"
# kick-off first backup so that slaves can init from this master
include_recipe "db_mysql::do_backup"
