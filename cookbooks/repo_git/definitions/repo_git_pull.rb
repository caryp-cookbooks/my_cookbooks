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
        echo -n '#{params[:cred]}' > #{keyfile}
	chmod 700 #{keyfile}
        echo 'exec ssh -i #{keyfile} "$@"' > #{keyfile}.sh
	chmod +x #{keyfile}.sh
      EOH
    end
  end 

  # pull repo (if exist)
  ruby "pull-exsiting-local-repo" do
    cwd params[:dest]
    only_if do File.directory?(params[:dest]) end
    code <<-EOH
      puts "Updateing existing repo at #{params[:dest]}"
      ENV["GIT_SSH"] = "#{keyfile}.sh" unless ("#{keyfile}" == "")
      puts `git pull` 
    EOH
  end
  
  # clone repo (if not exist)
  ruby "create-new-local-repo" do
    not_if do File.directory?(params[:dest]) end
    code <<-EOH
      puts "Creating new repo at #{params[:dest]}"
      ENV["GIT_SSH"] = "#{keyfile}.sh" unless ("#{keyfile}" == "")
      puts `git clone #{params[:url]} -- #{params[:dest]}`

      if "#{params[:branch]}" != "master" 
	dir = "#{params[:dest]}"
        Dir.chdir(dir) 
        puts `git checkout --track -b #{params[:branch]} origin/#{params[:branch]}`
      end
    EOH
  end

  # delete SSH key & clear GIT_SSH
  if params[:cred] != nil
    bash 'delete_temp_git_ssh_key' do
      code <<-EOH
        rm -f #{keyfile}
        rm -f #{keyfile}.sh
      EOH
    end
  end

end
