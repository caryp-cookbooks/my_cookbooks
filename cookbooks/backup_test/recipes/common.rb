rs_tools "rightscale_dbtools-0.19.0.tgz"

BACKUP_TEST_DATA_DIR    = "/mnt/backup_test"
BACKUP_TEST_MOUNT_POINT = "/mnt"
BACKUP_TEST_RESTORE_DIR = "#{BACKUP_TEST_DATA_DIR}_new"
 
# Remove any restore directory from previous runs.
directory BACKUP_TEST_RESTORE_DIR do
  action :delete
end

# Setup remote storage object. 
# Stores to Amazon S3 or Rackspace CloudFiles.
#
remote_object_store "RemoteObjectStore" do
  user node[:test][:username]
  key node[:test][:password]
  container "regression_test_area"
  provider_type node[:test][:provider]
  action :create_container
end

# TODO: create a new provider to set this up
# without this the LVM must already be setup on filesystem
#
# lvm "create lvm" do
#   
# end

# Initialize the backup provider and prepair backup. 
# This will trigger the LVM snaphot.
backup "BackupTest" do
  mount_point BACKUP_TEST_MOUNT_POINT
  provider_type "LVM"
  storage_resource_name "RemoteObjectStore"
  action :prepare_backup
end

# Do the actual backup to our remote storage.
backup "BackupTest" do
  lineage "backup-test"
  file_list [ "backup_test" ]
  action :backup
end

# Do any cleanup needed. This will delete the snapshot.
backup "BackupTest" do
  action :cleanup_backup
end

# Create a palce to put our restore
directory BACKUP_TEST_RESTORE_DIR do
  action :create
end

# Do the restore.
backup "BackupTest" do
  restore_dir BACKUP_TEST_RESTORE_DIR
  action :restore
end

# Compare directories.
# Raise an exception if they are different.
ruby "test for identical dirs" do
  code <<-EOH
    `diff -r "#{BACKUP_TEST_DATA_DIR}" "#{BACKUP_TEST_RESTORE_DIR}"`
    raise "ERROR: directories do not match!!" if $? != 0
  EOH
end
