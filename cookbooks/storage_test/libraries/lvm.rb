module  RightScaleHelpers
  class LVM
    def initialize( mount_point )
       #@underlying_device = find_device(mount_point) # Or save the underlying device....
    end
    
    def create_lvm_snapshot( dbbackup_name , destination)
      Chef::Log.info( "We should be creating an lvm snap from device X onto (#{destination})")
    end
    
  end
end
  