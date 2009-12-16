COOKBOOK_PATH = "/root/my_cookbooks"

# does the custom cookbook path already exist?
already_run = ::File.directory?(COOKBOOK_PATH)
Chef::Log.info "Custom cookbook path exists = #{already_run}"

# if not, add tag to instance and...
right_link_tag "rs_agent_dev:cookbooks_path=#{COOKBOOK_PATH}/cookbooks" do
  not_if do already_run end
end

# ...copy test cookbooks to COOKBOOK_PATH, then...
ruby "copy this repo" do
  not_if do already_run end
  code <<-EOH
    `mkdir #{COOKBOOK_PATH}`
    `cp -r #{::File.join(File.dirname(__FILE__), "..", "..", "..","*")} #{COOKBOOK_PATH}`
  EOH
end

#TODO: add a reboot count check and fail if count > 3

# ..reboot!
ruby_block "reboot" do
 not_if do already_run end
  block do
    `init 6`
  end
end