STORAGE_TEST_CONTAINER = "regression_test_area"
STORAGE_TEST_OBJECT_NAME = "storage_test"
STORAGE_TEST_FILE_PATH = "/tmp/storage_test"

# removed any file from previous test
file "#{STORAGE_TEST_FILE_PATH}.new" do
  action :delete
end

# create test file
template "#{STORAGE_TEST_FILE_PATH}.orig" do
  source "test_file.erb"
  variables ({
    :provider => "#{STORAGE_TEST_PROVIDER}",
    :container => "#{STORAGE_TEST_CONTAINER}",
    :object_name => "#{STORAGE_TEST_OBJECT_NAME}"
  })
end

# upload to S3
remote_object_store "#{STORAGE_TEST_FILE_PATH}.orig" do
  user USER_NAME
  key USER_PW
  container STORAGE_TEST_CONTAINER
  object_name STORAGE_TEST_OBJECT_NAME 
  provider_type STORAGE_TEST_PROVIDER
  action :put
end

# download from S3
remote_object_store "#{STORAGE_TEST_FILE_PATH}.new" do
  user USER_NAME
  key USER_PW
  container STORAGE_TEST_CONTAINER
  object_name STORAGE_TEST_OBJECT_NAME  
  provider_type STORAGE_TEST_PROVIDER
  action :get
end

# remove file from S3
remote_object_store "remove file" do
  user USER_NAME
  key USER_PW
  container STORAGE_TEST_CONTAINER
  object_name STORAGE_TEST_OBJECT_NAME  
  provider_type STORAGE_TEST_PROVIDER
  action :delete
end

# compare files
ruby "test for identical files" do
  code <<-EOH
    `diff "#{STORAGE_TEST_FILE_PATH}.orig" "#{STORAGE_TEST_FILE_PATH}.new"`
    raise "ERROR: files do not match!!" if $? != 0
  EOH
end
