TAG = "rs_agent_dev:break_point=rightlink_test::tag_break_point_test_should_never_run"
UUID = node[:rightscale][:instance_uuid]
UUID_TAG = "rs_instance:uuid=#{UUID}"

log "Add our instance UUID as a tag: #{UUID_TAG}"
right_link_tag UUID_TAG

log "Query servers for our tags..."
server_collection UUID do
  tags UUID_TAG
end

# Check query results to see if we have our TAG set.
ruby_block "Query for breakpoint" do
  block do
    Chef::Log.info("Checking server collection for tag...")
    h = node[:server_collection][UUID]
    tags = h[h.keys[0]]
    Chef::Log.info("Tags:#{tags}")
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
    Chef::Log.info "Rebooting so breakpoint tag will take affect."
    `init 6`
  end
end
