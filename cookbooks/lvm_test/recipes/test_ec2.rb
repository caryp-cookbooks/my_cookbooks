include_recipe "lvm::default"

LVM_RESOURCE_NAME = "test_lvm"
LVM_SNAPSHOT_NAME = "test_lvm_snapshot"

# create LVM
lvm LVM_RESOURCE_NAME do
  action :create
end

# create snapshot
lvm LVM_RESOURCE_NAME do
  snapshot_name LVM_SNAPSHOT_NAME
  action :snapshot_create
end

# snapshot should exist
lvm LVM_RESOURCE_NAME do
  snapshot_name LVM_SNAPSHOT_NAME
  action :snapshot_check
end

# delete snapshot
lvm LVM_RESOURCE_NAME do
  snapshot_name LVM_SNAPSHOT_NAME
  action :snapshot_delete
end

# snapshot should NOT exist
lvm LVM_RESOURCE_NAME do
  snapshot_name LVM_SNAPSHOT_NAME
  snapshot_exists false
  action :snapshot_check
end