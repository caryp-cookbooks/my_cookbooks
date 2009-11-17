node[:storage_test][:provider] = "CloudFiles"
node[:storage_test][:username] = node[:storage_test][:cloudfiles][:user]
node[:storage_test][:password] = node[:storage_test][:cloudfiles][:key]

include_recipe 'storage_test::common'
