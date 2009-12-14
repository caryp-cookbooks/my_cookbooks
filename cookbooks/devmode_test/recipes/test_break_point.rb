# server_collection "Get breakpoint tags" do
#   tags "rs_agent_dev:break_point=*"
# end
# 
# right_link_tag "set breakpoint" do
#   not_if 

class Chef::Recipe
  include RightScale::ServerCollection
end

Chef::Log.info("CKP:server collection: #{get_collection('*')}")
