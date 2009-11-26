include_recipe "lvm::default"

LVM_RESOURCE_NAME = "test_lvm"
LVM_SNAPSHOT_NAME = "test_lvm_snapshot"

# create LVM
filesystem LVM_RESOURCE_NAME do
  mount_point "/mnt"
  action :create
end

# delete snapshot
filesystem LVM_RESOURCE_NAME do
  snapshot_name LVM_SNAPSHOT_NAME
  action :snapshot_delete
end

# create snapshot
filesystem LVM_RESOURCE_NAME do
  snapshot_name LVM_SNAPSHOT_NAME
  action :snapshot_create
end

# snapshot should exist
filesystem LVM_RESOURCE_NAME do
  snapshot_name LVM_SNAPSHOT_NAME
  action :snapshot_check
end

# delete snapshot
filesystem LVM_RESOURCE_NAME do
  snapshot_name LVM_SNAPSHOT_NAME
  action :snapshot_delete
end

# snapshot should NOT exist
filesystem LVM_RESOURCE_NAME do
  snapshot_name LVM_SNAPSHOT_NAME
  snapshot_exists false
  action :snapshot_check
end
