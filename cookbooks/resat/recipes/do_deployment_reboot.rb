include_recipe "resat::setup_test_variables"

execute "resat -f -c #{config_file} #{senario_root}/reboot.yaml -s #{schema_path} -F #{log_file}"
