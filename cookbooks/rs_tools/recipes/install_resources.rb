SANDBOX_BIN_DIR = "/opt/rightscale/sandbox/bin"
RESOURCE_GEM = ::File.join(::File.dirname(__FILE__), "..", "files", "default", "right_resources_premium-0.0.1.gem")
RACKSPACE_GEM = ::File.join(::File.dirname(__FILE__), "..", "files", "default", "right_rackspace-0.0.0.gem")

# Install resources gem
resource_gem_path = ::File.join(Gem.path.last, 'gems', "right_resources_premium-0.0.1")
unless ::File.exists?(resource_gem_path)
  Chef::Log.info("premium resources gem not found at #{resource_gem_path}, installing")
  r = gem_package RESOURCE_GEM do
    gem_binary "#{SANDBOX_BIN_DIR}/gem"
    version "0.0.1"
    action :nothing
  end
  r.run_action(:install)
end

#
# Install provider dependencies
#

# system_timer
r = gem_package "SystemTimer" do
  gem_binary "#{SANDBOX_BIN_DIR}/gem"
  action :nothing
end
r.run_action(:install)

# right_aws
r = gem_package "right_aws" do
  gem_binary "#{SANDBOX_BIN_DIR}/gem"
  action :nothing
end
r.run_action(:install)

# right_rackspace
r = gem_package RACKSPACE_GEM do
  gem_binary "#{SANDBOX_BIN_DIR}/gem"
  version "0.0.0"
  action :nothing
end
r.run_action(:install)

Gem.clear_paths

include_recipe "rs_tools::do_resource_load"
