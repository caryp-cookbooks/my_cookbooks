node[:storage_test][:provider] = "S3"
node[:storage_test][:username] = node[:storage_test][:s3][:user]
node[:storage_test][:password] = node[:storage_test][:s3][:key]

include_recipe 'storage_test::common'
