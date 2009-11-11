include_recipe "db_mysql::do_lookup_master"

if node[:db][:this_is_master]
  include_recipe "db_mysql::setup_master_backup"
else
  include_recipe "db_mysql::setup_slave_backup"
end
