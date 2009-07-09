#
# Cookbook Name:: repo_git
# Definition:: repo_git_pull
#
require 'uri'

define :repo_git_pull, url => nil, branch => "master", dest => nil, cred => nil do
   
  # add repository credentials
  keyfile = nil
  if params[:cred] != nil
    keyfile = "/tmp/gitkey"
    bash 'create_temp_git_ssh_key' do
      code <<-EOH
        echo -n #{params[:cred]} > #{keyfile}
        exec ssh -i #{keyfile} "$@"
      EOH
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
      ENV["GIT_SSH"] = #{keyfile}

      `cd params[:dest].split('/').last.sub(/\.git/i,'')`
      `git pull` 
    EOH
  end
  
  # clone repo (if not exist)
  ruby "create-new-local-repo" do
    cwd params[:dest]
    not_if do File.directory?(params[:dest].split('/').last.sub(/\.git/i,'')) end
    code <<-EOH
      ENV["GIT_SSH"] = #{keyfile}

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

  # delete SSH key & clear GIT_SSH
  if params[:cred] != nil
    bash 'delete_temp_git_ssh_key' do
      code <<-EOH
        rm -f #{keyfile}
      EOH
    end
  end

end
