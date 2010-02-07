set_unless[:cucumber][:tags] = nil 

set_unless[:rest_connection][:api][:user] = nil
set_unless[:rest_connection][:api][:password] = nil
set_unless[:rest_connection][:api][:url] = nil

set_unless[:resat][:git_key] = nil
set_unless[:resat][:test][:type] = nil
set_unless[:resat][:test][:template] = nil
set_unless[:resat][:test][:os] = nil

set_unless[:resat][:base_dir] = "/root"
set_unless[:resat][:log_file] = "/root/resat.log"

