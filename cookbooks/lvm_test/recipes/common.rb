include_recipe "lvm::install"

LVM_RESOURCE_NAME = "default" # currently hard coded

LVMROS_TEST_PROVIDER = node[:test][:provider]
LVMROS_TEST_CONTAINER = "regression_test_area"

BACKUP_TEST_MOUNT_POINT = "/mnt"
BACKUP_TEST_RESTORE_DIR = "/tmp/restore_test"

# Remove any restore directory from previous runs.
directory BACKUP_TEST_RESTORE_DIR do
  action :delete
  recursive true
end

node[:remote_storage][:default][:account][:id] = node[:test][:username]
node[:remote_storage][:default][:account][:credentials] = node[:test][:password]
node[:remote_storage][:default][:provider] = LVMROS_TEST_PROVIDER
node[:remote_storage][:default][:container] = LVMROS_TEST_CONTAINER

include_recipe "lvm::setup_remote_storage"
include_recipe "lvm::setup_lvm"


# Populate with some files
directory "/mnt/backup_test" 
file "/mnt/backup_test/a.txt"
file "/mnt/backup_test/b.txt"
directory "/mnt/backup_test/c" 
file "/mnt/backup_test/c/c.txt"

# Take snapshots
block_device LVM_RESOURCE_NAME do
  action :take_snapshot 
end

# Do the actual backup.
block_device LVM_RESOURCE_NAME do
  action :backup 
end

# Create a palce to put our restore
directory BACKUP_TEST_RESTORE_DIR do
  action :create
end

# Do the restore.
block_device LVM_RESOURCE_NAME do
  restore_root BACKUP_TEST_RESTORE_DIR
  action :restore 
end

# Compare directories.
# Raise an exception if they are different.
ruby "test for identical dirs" do
  code <<-EOH
    `diff -r "#{BACKUP_TEST_MOUNT_POINT}" "#{BACKUP_TEST_RESTORE_DIR}"`
    raise "ERROR: directories do not match!!" if $? != 0
  EOH
end