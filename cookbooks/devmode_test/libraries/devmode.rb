# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
module RightScale
  module ServerCollection
    
    def get_collection(collection_name)
      raise "No server collection found with name = #{collection_name}" unless @node[:server_collection] && @node[:server_collection].has_key?(collection_name)
      return @node[:server_collection][collection_name]
    end  

  end
end

