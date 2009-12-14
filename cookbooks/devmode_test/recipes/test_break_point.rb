COLLECTION_NAME = "breakpoints"

server_collection COLLECTION_NAME do
#  tags "rs_agent_dev:break_point=*"
  tags "rs_agent_dev:"
end

ruby_block "debug" do
  block do
    collection = RightScale::MyServerCollection.new(node)
    
    Chef::Log.info("CKP:server collection: #{collection.get_collection('breakpoints').inspect}")
    
  end
end


# right_link_tag "set breakpoint" do
#   not_if 
