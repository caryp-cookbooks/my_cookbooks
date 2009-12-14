COLLECTION_NAME = "breakpoints"

server_collection COLLECTION_NAME do
#  tags "rs_agent_dev:break_point=devmode_test::test_should_never_run"
  tags "rs_agent_dev:"
end

ruby_block "debug" do
  block do
    class RightScale
      class MyServerCollection
    
        def initialize(node)
          super()
          @node = node
        end
        
        def get_collection(collection_name)
          raise "No server collection found with name = #{collection_name}" unless @node[:server_collection] && @node[:server_collection].has_key?(collection_name)
          return @node[:server_collection][collection_name]
        end  

      end
    end
    
    collection = RightScale::MyServerCollection.new(node)
    
    Chef::Log.info("CKP:server collection: #{collection.get_collection('breakpoints').inspect}")
    
    #node[:devmode_test][:has_breakpoint] = collection.
    
  end
end


# right_link_tag "set breakpoint" do
#   not_if 
