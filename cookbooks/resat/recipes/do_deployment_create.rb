include_recipe "resat::setup_test_variables"

execute "resat -f -c #{config_file} #{senario_root}/create.yaml -s #{schema_path} -F #{log_file}"

execute "cp /root/variables.txt /root/variables1.txt"