# Cookbook Name:: app_rails
# Recipe:: update_code
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#

log "URL: #{@node[:rails][:code][:url]}"
log "BRANCH: #{@node[:rails][:code][:branch]}"
log "USER: #{@node[:rails][:code][:user]}"
log "DESTINATION: #{@node[:rails][:code][:destination]}"
log "CREDENTIALS: #{@node[:rails][:code][:credentials]}"

# Check that we have the required attributes set
raise "You must provide a URL to your application code repository" if ("#{@node[:rails][:code][:url]}" == "") 
raise "You must provide a destination for your application code." if ("#{@node[:rails][:code][:destination]}" == "") 

# Warn about missing optional attributes
Chef::Log.warn("WARNING: You did not provide credentials for your code repository -- assuming public repository.") if ("#{@node[:rails][:code][:credentials]}" == "") 
Chef::Log.info("You did not provide branch informaiton -- setting to default.") if ("#{@node[:rails][:code][:branch]}" == "") 

# grab application source from remote repository
repo_git_pull "Get Repository" do
  url @node[:rails][:code][:url]
  branch @node[:rails][:code][:branch] 
  user @node[:rails][:code][:user]
  dest @node[:rails][:code][:destination]
  cred @node[:rails][:code][:credentials]
end
