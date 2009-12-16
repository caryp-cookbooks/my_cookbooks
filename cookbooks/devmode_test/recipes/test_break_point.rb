TAG = "rs_agent_dev:break_point=devmode_test::test_should_never_run"
UUID = node[:rightscale][:instance_uuid]
UUID_TAG = "rs_instance:uuid=#{UUID}"

# Add our instance UUID as a tag
right_link_tag UUID_TAG

# Query servers for our breakpoint tag...
server_collection UUID do
  tags UUID_TAG
end

# Check query results to see if we have the breakpoint set.
ruby_block "debug" do
  block do
    Chef::Log.info("Checking server collection for breakpoint tag...")
    h = node[:server_collection][UUID]
    tags = h[h.keys[0]]
    tag = tags.select { |s| s == TAG }
    if tag
      Chef::Log.info("  We have a breakpoint set!")
      node[:devmode_test][:has_breakpoint] = true
    else
      Chef::Log.info("  No breakpoint tag set -- set and reboot!") 
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
