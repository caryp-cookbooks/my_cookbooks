COLLECTION_NAME = "breakpoints"

server_collection COLLECTION_NAME do
#  tags "rs_agent_dev:break_point=*"
  tags "rs_agent_dev:"
end

ruby "debug" do
  code <<-EOH
    module RightScale
      module ServerCollection
    
        def breakpoint_set?(instance_uuid)
      
        end
    
        def get_collection(collection_name)
          raise "No server collection found with name = #{collection_name}" unless @node[:server_collection] && @node[:server_collection][collection_name]
          return @node[:server_collection][collection_name]
        end  

      end
    end
    class  Chef::Resource::Ruby
      include RightScale::ServerCollection
    end
    Chef::Log.info("CKP:server collection: #{get_collection(COLLECTION_NAME)}")
  EOH
end


# right_link_tag "set breakpoint" do
#   not_if 
