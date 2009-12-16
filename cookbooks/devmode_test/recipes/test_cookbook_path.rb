COOKBOOK_PATH = "/root/my_cookbooks"
COOKBOOK_TAG = "rs_agent_dev:cookbooks_path=#{COOKBOOK_PATH}/cookbooks"
COLLECTION_NAME = "cookbooks"

# Add our instance UUID as a tag
right_link_tag "rs_instance:uuid=#{node[:rightscale][:instance_uuid]}"

# Query servers for our breakpoint tag...
server_collection COLLECTION_NAME do
  tags COOKBOOK_TAG
end

# Check query results to see if we have the breakpoint set.
ruby_block "debug" do
  block do
    Chef::Log.info("Checking server collection for cookbooks tag...")
    uuids = [ ]
    node[:server_collection][COLLECTION_NAME].each do |id, tags|
      uuids = tags.select { |s| s =~ /rs_instance:uuid/ }
    end 
    # is our uuid in this list of tags?
    uuids.each do |tag|
      uuid = tag.split("=").last
      if uuid == node[:rightscale][:instance_uuid]
        Chef::Log.info("  We have custom cookbook tag set!")
        node[:devmode_test][:loaded_custom_cookbooks] = true
        break;
      end
    end
    Chef::Log.info("  No custom cookbook tag set -- set and reboot!") unless node[:devmode_test][:loaded_custom_cookbooks]
  end
end

# if not, add tag to instance and...
right_link_tag COOKBOOK_TAG do
  not_if do node[:devmode_test][:loaded_custom_cookbooks] end
end

# ...copy test cookbooks to COOKBOOK_PATH, then...
ruby "copy this repo" do
  not_if do node[:devmode_test][:loaded_custom_cookbooks] end
  code <<-EOH
    `mkdir #{COOKBOOK_PATH}`
    `cp -r #{::File.join(File.dirname(__FILE__), "..", "..", "..","*")} #{COOKBOOK_PATH}`
  EOH
end

#TODO: add a reboot count check and fail if count > 3

# ..reboot!
ruby_block "reboot" do
 not_if do node[:devmode_test][:loaded_custom_cookbooks] end
  block do
    `init 6`
  end
end