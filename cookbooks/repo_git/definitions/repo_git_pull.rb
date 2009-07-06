#
# Cookbook Name:: repo_git
# Definition:: repo_git_pull
#
require 'uri'

define :repo_git_pull, url => nil, branch => "master", dest => nil, cred => nil do
   
  # add repository credentials
  if params[:cred] != nil 

    #set filenames based on hostname, make sure it is only lowercase alphanumeric
    begin
      uri = URI.parse(params[:url])
      user = uri.user
      host = uri.host
    rescue
      puts "WARNING: Use ssh://[user@]host.xz/path/to/repo.git/ syntax when accessing private GIT repositories"
      raise URI::BadURIError
    end

    ssh_params = params # workaround for chef bug http://tickets.opscode.com/browse/CHEF-422

    auth_ssh_add_cred "add_credential_for_repo" do 
      user user
      host host
      template "git.erb"
      cred ssh_params[:cred]
    end
  end 
  
  # make parent dir (if not exist)
  directory params[:dest] do 
    action :create
    not_if do File.directory?(params[:dest]) end
  end
  
  # pull repo (if exist)
  ruby "pull-exsiting-local-repo" do
    cwd params[:dest]
    only_if do File.directory?(params[:dest].split('/').last.sub(/\.git/i,'')) end
    code <<-EOH
      `cd params[:dest].split('/').last.sub(/\.git/i,'')`
      `git pull` 
    EOH
  end
  
  # clone repo (if not exist)
  ruby "create-new-local-repo" do
    cwd params[:dest]
    not_if do File.directory?(params[:dest].split('/').last.sub(/\.git/i,'')) end
    code <<-EOH
      ## Ripped off from staging
      
      # First we create an empty repo and then we set up a remote branch tracker
      # The tracker will copy only the relevant branch (-t flag), and then map
      # that branch to the local master (-m flag)
      `git init`
      `git remote add -t '#{params[:branch]}' -m '#{params[:branch]}' origin #{params[:url]}`
      # Now we actually pull the data from remote
      `git fetch --depth 4 `
      # And "checkout" the branch (merge into empty master)
      `git merge origin/#{params[:branch]}`
    EOH
  end

end
