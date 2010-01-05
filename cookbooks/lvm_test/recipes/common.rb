include_recipe "lvm::install"

LVM_RESOURCE_NAME = "default" # currently hard coded

LVMROS_TEST_PROVIDER = node[:test][:provider]
LVMROS_TEST_CONTAINER = "regression_test_area"
LVMROS_TEST_FILENAME = "lvmros_test"
LVMROS_TEST_FILE_PATH = ::File.join(node[:lvm][:default][:mount_point], LVMROS_TEST_FILENAME)
LVMROS_TEST_RESTORE_PATH = "/tmp"

node[:remote_storage][:default][:account][:id] = node[:test][:username]
node[:remote_storage][:default][:account][:credentials] = node[:test][:password]
node[:remote_storage][:default][:provider] = LVMROS_TEST_PROVIDER
node[:remote_storage][:default][:container] = LVMROS_TEST_CONTAINER

include_recipe "lvm::setup_remote_storage"
include_recipe "lvm::setup_lvm"

# remove any file from previous test
file "#{LVMROS_TEST_FILE_PATH}.new" do
  action :delete
end

# create test file
template "#{LVMROS_TEST_FILE_PATH}" do
  source "test_file.erb"
  variables ({
    :provider => "#{LVMROS_TEST_PROVIDER}",
    :container => "#{LVMROS_TEST_CONTAINER}"
  })
end

# Take snapshots
block_device LVM_RESOURCE_NAME do
  action :take_snapshot 
end

# backup snapshot
block_device LVM_RESOURCE_NAME do
  action :backup 
end

# restore snapshot
block_device LVM_RESOURCE_NAME do
  restore_root LVMROS_TEST_RESTORE_PATH
  action :restore 
end

# compare files
ruby "test for identical files" do
  code <<-EOH
    `diff "#{LVMROS_TEST_FILE_PATH}" "#{::File.join(LVMROS_TEST_RESTORE_PATH, LVMROS_TEST_FILENAME)}"`
    raise "ERROR: files do not match!!" if $? != 0
  EOH
end