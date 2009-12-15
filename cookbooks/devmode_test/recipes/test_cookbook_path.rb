COOKBOOK_PATH = "~/my_cookbooks"
already_run = ::File.exists?(COOKBOOK_PATH)
Chef::Log.info "Custom cookbook path exists = #{already_run}"

# Add tag to instance
right_link_tag "rs_agent_dev:cookbooks_path=#{COOKBOOK_PATH}" do
  not_if already_run
end

# Copy test cookbooks to COOKBOOK_PATH
ruby "copy this repo" do
  not_if already_run
  cb_root = 

  code <<-EOH
    `mkdir #{COOKBOOK_PATH}`
    `cp -r #{::File.join(File.dirname(__FILE__), "..", "..", "..","*")} #{COOKBOOK_PATH}`
  EOH
end

# reboot
# ruby_block "reboot" do
#   not_if already_run
#   block do
#     `init 6`
#   end
# end