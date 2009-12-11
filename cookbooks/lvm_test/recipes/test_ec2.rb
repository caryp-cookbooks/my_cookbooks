include_recipe "lvm::default"

LVM_RESOURCE_NAME = "test_lvm"
LVM_SNAPSHOT_NAME = "test_lvm_snapshot"
LVM_SNAPSHOT_COUNT = 1

# Create LVM
filesystem LVM_RESOURCE_NAME do
  mount_point "/mnt"
  fstype node[:lvm][:fs][:type]
  format_options node[:lvm][:fs][:options]
  action :create
end

# Delete snapshots
LVM_SNAPSHOT_COUNT.times do |num|
  filesystem LVM_RESOURCE_NAME do
    snapshot_name "#{LVM_SNAPSHOT_NAME}_#{num}"
    action :snapshot_delete
  end
end


LVM_SNAPSHOT_COUNT.times do |num|
  # Create snapshots
  filesystem LVM_RESOURCE_NAME do
    snapshot_name "#{LVM_SNAPSHOT_NAME}_#{num}"
    action :snapshot_create
  end

  # Snapshots should exist 
  filesystem LVM_RESOURCE_NAME do
    snapshot_name "#{LVM_SNAPSHOT_NAME}_#{num}"
    action :snapshot_check
  end
end

LVM_SNAPSHOT_COUNT.times do |num|
  # Delete snapshots
  filesystem LVM_RESOURCE_NAME do
    snapshot_name "#{LVM_SNAPSHOT_NAME}_#{num}"
    action :snapshot_delete
  end

  # Snapshot should NOT exist
  filesystem LVM_RESOURCE_NAME do
    snapshot_name "#{LVM_SNAPSHOT_NAME}_#{num}"
    snapshot_exists false
    action :snapshot_check
  end
end

# Delete LVM
filesystem LVM_RESOURCE_NAME do
  action :remove
end