node[:storage_test][:provider] = "CloudFiles"
node[:storage_test][:username] = node[:storage_test][:rackspace][:user]
node[:storage_test][:password] = node[:storage_test][:rackspace][:key]

include_recipe 'storage_test::common'
