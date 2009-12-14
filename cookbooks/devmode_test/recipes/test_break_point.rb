COLLECTION_NAME = "breakpoints"

server_collection COLLECTION_NAME do
#  tags "rs_agent_dev:break_point=*"
  tags "*"
end

ruby "debug" do
  code <<-EOH
    include RightScale::ServerCollection
    Chef::Log.info("CKP:server collection: #{get_collection(COLLECTION_NAME)}")
  EOH
end


# right_link_tag "set breakpoint" do
#   not_if 
