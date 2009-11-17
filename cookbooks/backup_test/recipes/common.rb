#rs_tools "rightscale_dbtools-0.19.0.tgz"

STORAGE_TEST_PROVIDER = node[:test][:provider]
USER_NAME = node[:test][:username]
USER_PW = node[:test][:password]
STORAGE_TEST_CONTAINER = "regression_test_area"
STORAGE_TEST_OBJECT_NAME = "storage_test"
STORAGE_TEST_FILE_PATH = "/tmp/storage_test"

BACKUP_TEST_DATA_DIR = "/mnt/backup_test"
BACKUP_TEST_MOUNT_POINT = "/mnt"
BACKUP_TEST_PROVIDER = "LVM"
BACKUP_TEST_LINEAGE = "backup-test"

remote_object_store "RemoteObjectStore" do
  user USER_NAME
  key USER_PW
  container STORAGE_TEST_CONTAINER
  provider_type STORAGE_TEST_PROVIDER
  action :create_container
end

# lvm "create lvm" do
#   
# end

backup "BackupTest" do
  mount_point BACKUP_TEST_MOUNT_POINT
  provider_type BACKUP_TEST_PROVIDER
  data_dir BACKUP_TEST_DATA_DIR
  storage_resource_name "RemoteObjectStore"
  action :prepare_backup
end

backup "BackupTest" do
  backup_lineage BACKUP_TEST_LINEAGE
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
ruby "test for identical dirs" do
  code <<-EOH
    `diff -R "#{BACKUP_TEST_MOUNT_POINT}" "#{BACKUP_TEST_MOUNT_POINT}_new"`
    raise "ERROR: directories do not match!!" if $? != 0
  EOH
end
