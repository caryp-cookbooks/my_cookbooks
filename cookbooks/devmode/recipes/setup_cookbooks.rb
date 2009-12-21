COOKBOOKS_PATH = "/root/my_cookbooks/cookbooks,/root/premium/cookbooks,/root/public/cookbooks,/root/opscode"
TAG = "rs_agent_dev:cookbooks_path=#{COOKBOOKS_PATH}"
UUID = node[:rightscale][:instance_uuid]
UUID_TAG = "rs_instance:uuid=#{UUID}"

# Add our instance UUID as a tag
right_link_tag UUID_TAG

# Query servers for our cookbook tag...
server_collection UUID do
  tags UUID_TAG
end

# Check query results to see if we have our TAG set.
ruby_block "Query for cookbook" do
  block do
    Chef::Log.info("Checking server collection for tag...")
    h = node[:server_collection][UUID]
    tags = h[h.keys[0]]
    
    result = []
    if tags
      result = tags.select { |s| s == TAG }
    end
  
    unless result.empty?
      Chef::Log.info("  Tag found!")
      node[:devmode][:loaded_custom_cookbooks] = true
    else
      Chef::Log.info("  No tag found -- set and reboot!") 
    end
  end
end


SETUP_FILE = "/root/Dropbox/setup_instance_links.sh"
ruby_block "wait for setup file" do
  not_if do node[:devmode][:loaded_custom_cookbooks] end
  block do
    while ! ::File.exsits?(SETUP_FILE)
      Chef::Log.info("Waiting for #{SETUP_FILE}...")
      Kernel.sleep 60
    end
  end
end

ruby_block "call setup file" do
  not_if do node[:devmode][:loaded_custom_cookbooks] end
  block do
    Chef::Log.info("Executing #{SETUP_FILE}...")
    `chmod +x #{SETUP_FILE}`
    `#{SETUP_FILE}`
  end
end

# Tell RightLink where to find your development cookbooks
# if not, add tag to instance and...
right_link_tag TAG do
  not_if do node[:devmode_test][:loaded_custom_cookbooks] end
end

# ..reboot!
ruby_block "reboot" do
 not_if do node[:devmode_test][:loaded_custom_cookbooks] end
  block do
    `init 6`
  end
end
