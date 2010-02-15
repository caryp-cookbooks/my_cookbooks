COOKBOOK_PATH = "/root/my_cookbooks"
TAG = "rs_agent_dev:cookbooks_path=#{COOKBOOK_PATH}/cookbooks"
UUID = node[:rightscale][:instance_uuid]
UUID_TAG = "rs_instance:uuid=#{UUID}"

# Add our instance UUID as a tag
right_link_tag UUID_TAG

# Query servers for our UUID tag...
server_collection UUID do
  tags UUID_TAG
end

# Check query results to see if we have our TAG set.
ruby_block "Query for cookbook path" do
  block do
    Chef::Log.info("Checking server collection for tag...")
    h = node[:server_collection][UUID]
    tags = h[h.keys[0]]
    result = tags.select { |s| s == TAG }
    unless result.empty?
      Chef::Log.info("  Tag found!")
      node[:devmode_test][:loaded_custom_cookbooks] = true
    else
      Chef::Log.info("  No tag found -- set and reboot!") 
    end
  end
end

# if not, add tag to instance and...
right_link_tag TAG do
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