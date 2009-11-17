STORAGE_TEST_PROVIDER = "CloudFiles"
USER_NAME = node[:storage_test][:rackspace][:user]
USER_PW = node[:storage_test][:rackspace][:key]

include_recipe 'storage_test::common'