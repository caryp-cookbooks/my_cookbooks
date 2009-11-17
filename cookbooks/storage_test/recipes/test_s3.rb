STORAGE_TEST_PROVIDER = "S3"
USER_NAME = node[:storage_test][:s3][:user]
USER_PW = node[:storage_test][:s3][:key]

include_recipe 'storage_test::common'
