#
# Cookbook Name:: backup_test
# Recipe:: common
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
include_recipe "backup"

BACKUP_TEST_FILE_LIST    = [ "backup_test" ]
BACKUP_TEST_MOUNT_POINT = "/mnt"
BACKUP_TEST_RESTORE_DIR = "/tmp/restore_test"
 
# Remove any restore directory from previous runs.
directory BACKUP_TEST_RESTORE_DIR do
  action :delete
  recursive true
end

# clean up extra good for developer testing
Dir.glob("/tmp/lvm_backup_file_list*").each do |tmpfile|
  file tmpfile do
    action :delete
  end
end

# Setup remote storage object. 
# Stores to Amazon S3 or Rackspace CloudFiles.
#
remote_storage "RemoteObjectStore" do
  user node[:test][:username]
  key node[:test][:password]
  container "regression_test_area"
  provider_type node[:test][:provider]
  action :create_container
end

# Setup filesystem for snapshoting
filesystem "lvm_filesystem" do
   mount_point BACKUP_TEST_MOUNT_POINT
   snapshot_name "backup_test_snapshot"
   action :create
end

# populate with some files
directory "/mnt/backup_test" 
file "/mnt/backup_test/a.txt"
file "/mnt/backup_test/b.txt"
directory "/mnt/backup_test/c" 
file "/mnt/backup_test/c/c.txt"

# Initialize the backup provider and prepair backup. 
# This will trigger the LVM snaphot.
backup "BackupTest" do
  provider_type "LVMROS"   #TODO: this param should be auto-set by filesystem provider type
  filesystem_resource_name "lvm_filesystem"
  storage_resource_name "RemoteObjectStore"
  action :prepare_backup
end

# Do the actual backup to our remote storage.
backup "BackupTest" do
  lineage "backup-test"
  file_list BACKUP_TEST_FILE_LIST
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
