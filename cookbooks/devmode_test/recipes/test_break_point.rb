COLLECTION_NAME = "breakpoints"

right_link_tag "rs_instance:uuid=#{node[:rightscale][:instance_uuid]}"

server_collection COLLECTION_NAME do
#  tags "rs_agent_dev:break_point=devmode_test::test_should_never_run"
  tags "rs_agent_dev:"
end

ruby_block "debug" do
  block do
    uuids = {}
    node[:server_collection]["breakpoints"].each do |id, tags|
      uuids = tags.select { |s| s =~ /rs_instance:uuid/ }
    end 
    
    Chef::Log.info("CKP: uuids: #{uuids.inspect}")
    
  end
end


# right_link_tag "set breakpoint" do
#   not_if 
