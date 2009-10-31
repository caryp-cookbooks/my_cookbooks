action :pull do
 
  Chef::Log.info "Running repo_svn::do_pull..."

  # setup parameters 
  params = "--no-auth-cache --non-interactive"
  params << " --username #{@node[:svn][:username]} --password #{@node[:svn][:password]}" if "#{@node[:svn][:password]}" != ""
  params << " --revision #{@node[:svn][:revision]}" if "#{@node[:svn][:revision]}" != ""

  # pull repo (if exist)
  ruby "pull-exsiting-local-repo" do
    cwd new_resource.destination
    only_if do ::File.directory?(new_resource.destination) end
    code <<-EOH
      puts "Updateing existing repo at #{new_resource.destination}"
      puts `svn update #{params} #{@node[:svn][:repository]} #{new_resource.destination}` 
    EOH
  end

  # clone repo (if not exist)
  ruby "create-new-local-repo" do
    not_if do ::File.directory?(new_resource.destination) end
    code <<-EOH
      puts "Creating new repo at #{new_resource.destination}"
      puts `svn checkout #{params} #{@node[:svn][:repository]} #{new_resource.destination}`
    EOH
  end
 
end
