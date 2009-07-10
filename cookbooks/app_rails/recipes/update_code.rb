
# Check that we have the required attributes set
raise "You must provide a URL to your application code repository" if (@node[:rails][:code][:url] == false) 
raise "You must provide a destination for your application code." if (@node[:rails][:code][:destination] == false) 

# Warn about missing optional attributes
Chef::Log.warn("WARNING: You did not provide credentials for your code repository -- assuming public repository.") if (@node[:rails][:code][:credentials] == false) 
Chef::Log.info("You did not provide branch informaiton -- setting to default.") if (@node[:rails][:code][:branch] == false) 

# grab application source from remote repository
repo_git_pull "Get Repository" do
  url @node[:rails][:code][:url]
  branch @node[:rails][:code][:branch] 
  user @node[:rails][:code][:user]
  dest @node[:rails][:code][:destination]
  cred @node[:rails][:code][:credentials]
end
