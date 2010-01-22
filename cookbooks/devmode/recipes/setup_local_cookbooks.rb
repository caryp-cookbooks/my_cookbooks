TAG = "rs_agent_dev:cookbooks_path=" 
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
      result = tags.select { |s| s.include?(TAG) }
    end
  
    unless result.empty?
      Chef::Log.info("  Tag found!")
      node[:devmode][:loaded_custom_cookbooks] = true
    else
      Chef::Log.info("  No tag found -- set and reboot!") 
    end
  end
end

# /tmp/cookbooks.txt should be created by setup file.
ruby_block "symlink and set tags" do
  not_if do node[:devmode][:loaded_custom_cookbooks] end
  block do
    cookbooks = []
    cb = Dir.glob("/var/cache/rightscale/cookbooks/*")
    cb.each do |book|
      book =~ /_([a-zA-Z]+?_[a-zA-Z]+?)_git/
      shortname = $1
      dest = "/root/#{shortname}"
      unless File.exists?(dest)
        File.symlink(book, dest)
        cookbooks << dest
      end
    end
# convienient link for right_resources_premium editing
    File.symlink(File.join(Gem.path.last, "gems", "right_resources_premium_0.0.1"), "/root/right_resources_premium")

    node[:devmode][:cookbooks_tag] = "rs_agent_dev:cookbooks_path=#{cookbooks.join(",")}"
    Chef::Log.info("Adding tag = #{node[:devmode][:cookbooks_tag]}")
  end
end

# Tell RightLink where to find your development cookbooks
# if not, add tag to instance and...
# right_link_tag node[:devmode][:cookbooks_tag] do
#   not_if do node[:devmode_test][:loaded_custom_cookbooks] end
#   only_if do ::File.exists?(COOKBOOK_FILE) end
# end
ruby_block "hack provider with a dynamic tag name" do
  not_if do node[:devmode][:loaded_custom_cookbooks] end
  block do
    Chef::Log.info("Publishing tag...")
    resrc = Chef::Resource::RightLinkTag.new(node[:devmode][:cookbooks_tag])
    provider = Chef::Provider::RightLinkTag.new(node, resrc)
    provider.send("action_publish")
    Chef::Log.info("  ..done.")
  end
end

# only reboot if cookbook_path.txt is found!
 ruby_block "reboot" do
   not_if do node[:devmode][:loaded_custom_cookbooks] end
   block do
     `init 6`
   end
 end
