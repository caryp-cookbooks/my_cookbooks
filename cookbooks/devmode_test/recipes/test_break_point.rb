COLLECTION_NAME = "breakpoints"

server_collection COLLECTION_NAME do
#  tags "rs_agent_dev:break_point=*"
  tags "rs_agent_dev:"
end

ruby "debug" do
  code <<-EOH
    class RightScale
      class MyServerCollection
    
        def initialize
          super()
        end
    
        def get_collection(collection_name)
          raise "No server collection found with name = #{collection_name}" unless @node[:server_collection] && @node[:server_collection][collection_name]
          return @node[:server_collection][collection_name]
        end  

      end
    end
    
    collection = RightScale::MyServerCollection.new()
    
    Chef::Log.info("CKP:server collection: \#{collection.get_collection(COLLECTION_NAME)}")
  EOH
end


# right_link_tag "set breakpoint" do
#   not_if 
