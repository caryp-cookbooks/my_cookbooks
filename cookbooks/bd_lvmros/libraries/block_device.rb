# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
module RightScale
  module BlockDevice
    module EC2
      
      DRIVES_MAX = 100  # should be plenty -- no?
      
      def ephemeral_devices()
        ephem_devs = []
        DRIVES_MAX.times do |i|   
          key = "block_device_mapping_ephemeral#{i}"
          if ec2.has_key?(key)
            ephem_devs << "/dev/#{ec2[key]}"
          else
            break ephem_devs
          end
        end  
      end
    end
  end
end
