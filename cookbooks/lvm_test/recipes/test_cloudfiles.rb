node[:test][:provider] = "CloudFiles"
node[:test][:username] = node[:test][:cloudfiles][:user]
node[:test][:password] = node[:test][:cloudfiles][:key]

include_recipe 'lvm_test::common'
