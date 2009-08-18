
@node[:db_mysql][:dns][:master_name] = "reg-rails-db1.test.rightscale.com"
@node[:db_mysql][:dns][:master_id] = "3852588"

@node[:db_mysql][:backup][:prefix] ="rails_regression"

@node[:db_mysql][:dns][:user] = "payless"
@node[:db_mysql][:dns][:password] = "scalemore!"

include_recipe "db_mysql::backup"
