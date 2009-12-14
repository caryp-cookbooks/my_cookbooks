COOKBOOK_PATH = "~/my_cookbooks"
already_run = ::File.exists?(COOKBOOK_PATH)

# Add tag to instance
right_link_tag "rs_agent_dev:cookbooks_path=#{COOKBOOK_PATH}" do
  not_if already_run
end

# Copy test cookbooks to COOKBOOK_PATH
ruby "copy this repo" do
  not_if already_run
  code <<-EOH
    cb_root = ::File.join(__FILE__, "..", "..")
    `mkdir #{COOKBOOK_PATH}`
    `cp -r \#{cb_root}/* #{COOKBOOK_PATH}`
  EOH
end

# reboot
ruby_block "reboot" do
  not_if already_run
  block do
    `init 6`
  end
end