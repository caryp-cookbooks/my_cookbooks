TAG = "rs_agent_dev:break_point=rightlink_test::test_should_never_run"
UUID = node[:rightscale][:instance_uuid]
UUID_TAG = "rs_instance:uuid=#{UUID}"

# Add our instance UUID as a tag
right_link_tag UUID_TAG

# Query servers for our breakpoint tag...
server_collection UUID do
  tags UUID_TAG
end

# Check query results to see if we have our TAG set.
ruby_block "Query for breakpoint" do
  block do
    Chef::Log.info("Checking server collection for tag...")
    h = node[:server_collection][UUID]
    tags = h[h.keys[0]]
    result = tags.select { |s| s == TAG }
    unless result.empty?
      Chef::Log.info("  Tag found!")
      node[:devmode_test][:has_breakpoint] = true
    else
      Chef::Log.info("  No tag found -- set and reboot!") 
    end
  end
end

# Set breakpoint if not set.
right_link_tag TAG do
  not_if do node[:devmode_test][:has_breakpoint] end
end

#TODO: add a reboot count check and fail if count > 3

# Reboot, if not set
ruby_block "reboot" do
  not_if do node[:devmode_test][:has_breakpoint] end
  block do
    `init 6`
  end
end
