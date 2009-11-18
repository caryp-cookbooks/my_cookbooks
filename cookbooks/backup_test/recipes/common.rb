rs_tools "rightscale_dbtools-0.19.0.tgz"

BACKUP_TEST_DATA_DIR = "/mnt/backup_test"
BACKUP_TEST_MOUNT_POINT = "/mnt"

remote_object_store "RemoteObjectStore" do
  user node[:test][:username]
  key node[:test][:password]
  container "regression_test_area"
  provider_type node[:test][:provider]
  action :create_container
end

# lvm "create lvm" do
#   
# end

backup "BackupTest" do
  mount_point BACKUP_TEST_MOUNT_POINT
  provider_type "LVM"
  data_dir BACKUP_TEST_DATA_DIR
  lineage "backup-test"
  storage_resource_name "RemoteObjectStore"
  action :prepare_backup
end

backup "BackupTest" do
  action :backup
end

backup "BackupTest" do
  action :cleanup_backup
end

directory "#{BACKUP_TEST_MOUNT_POINT}_new" do
  action :create
end

backup "BackupTest" do
  mount_point "#{BACKUP_TEST_MOUNT_POINT}_new"
  action :restore
end

# compare directories
# FIXME: the backup and restore dirs are different!!
ruby "test for identical dirs" do
  code <<-EOH
    `diff -r "#{BACKUP_TEST_MOUNT_POINT}/#{BACKUP_TEST_DATA_DIR}" "#{BACKUP_TEST_MOUNT_POINT}_new"`
    raise "ERROR: directories do not match!!" if $? != 0
  EOH
end
