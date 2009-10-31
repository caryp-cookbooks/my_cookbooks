action :pull do
 
 Chef::Log.info "Running repo_git::do_pull..."
 
  # add ssh key and exec script
  keyfile = nil
  if "#{@node[:git][:ssh_key]}" != ""
    keyfile = "/tmp/gitkey"
    bash 'create_temp_git_ssh_key' do
      code <<-EOH
        echo -n '#{@node[:git][:ssh_key]}' > #{keyfile}
        chmod 700 #{keyfile}
        echo 'exec ssh -oStrictHostKeyChecking=no -i #{keyfile} "$@"' > #{keyfile}.sh
        chmod +x #{keyfile}.sh
      EOH
    end
  end 

  # pull repo (if exist)
  ruby "pull-exsiting-local-repo" do
    cwd new_resource.destination
    only_if do ::File.directory?(new_resource.destination) end
    code <<-EOH
      puts "Updateing existing repo at #{new_resource.destination}"
      ENV["GIT_SSH"] = "#{keyfile}.sh" unless ("#{keyfile}" == "")
      puts `git pull` 
    EOH
  end

  # clone repo (if not exist)
  ruby "create-new-local-repo" do
    not_if do ::File.directory?(new_resource.destination) end
    code <<-EOH
      puts "Creating new repo at #{new_resource.destination}"
      ENV["GIT_SSH"] = "#{keyfile}.sh" unless ("#{keyfile}" == "")
      puts `git clone #{@node[:git][:repository]} -- #{new_resource.destination}`

      if "#{@node[:git][:branch]}" != "master" 
        dir = "#{new_resource.destination}"
        Dir.chdir(dir) 
        puts `git checkout --track -b #{@node[:git][:branch]} origin/#{@node[:git][:branch]}`
      end
    EOH
  end

  # delete SSH key & clear GIT_SSH
  if keyfile != nil
     bash 'delete_temp_git_ssh_key' do
       code <<-EOH
         rm -f #{keyfile}
         rm -f #{keyfile}.sh
       EOH
     end
  end
 
end
