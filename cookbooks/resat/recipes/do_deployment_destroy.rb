include_recipe "resat::setup_test_variables"

execute "resat -c #{config_file} #{senario_root}/destroy.yaml -s #{schema_path} -F #{log_file}"
