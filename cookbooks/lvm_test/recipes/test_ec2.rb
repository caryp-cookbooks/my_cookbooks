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
  action :create_snapshot
end

# snapshot should exist
lvm LVM_RESOURCE_NAME do
  snapshot_name LVM_SNAPSHOT_NAME
  action :verify_snapshot_exists
end

# delete snapshot
lvm LVM_RESOURCE_NAME do
  snapshot_name LVM_SNAPSHOT_NAME
  action :delete_snapshot
end

# snapshot should NOT exist
lvm LVM_RESOURCE_NAME do
  snapshot_name LVM_SNAPSHOT_NAME
  snapshot_exists false
  action :verify_snapshot_exists
end