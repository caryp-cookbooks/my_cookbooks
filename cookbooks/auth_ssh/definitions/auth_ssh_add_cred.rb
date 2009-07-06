#
# Cookbook Name:: auth_ssh
# Definition:: auth_ssh_add_cred
#

define :auth_ssh_add_cred, user => "root", host=> "", template => nil, cred => nil do
  
  if params[:host] == nil
    #
    # setup ssh key for git repo 
    #
    file @node[:ssh][:keyfile] do
      owner "root"
      group "root"
      mode "0600"
      action :create
    end
    
    bash "write-private-key" do
      code "echo '#{params[:cred]}' > #{@node[:ssh][:keyfile]}"
    end
  
  else
    #
    # write key to custom keyfile and add to keychain for host
    #
    raise "An auth_ssh template must be provided for this host!" unless (params[:template] != nil)
    
    hostname = params[:host]
    keyfile = "key_#{hostname}"

    # add custom key file for specified host
    file "#{@node[:ssh][:dir]}/#{keyfile}" do
      owner "root"
      group "root"
      mode "0600"
      action :create
    end

    bash "write-to-host-private-key" do
      code "echo -n '#{params[:cred]}' > #{@node[:ssh][:dir]}/#{keyfile}"
    end

    directory @node[:ssh][:config_dir] do
      owner "root"
      group "root"
      mode "0700"
      action :create
    end

    template "#{@node[:ssh][:config_dir]}/#{hostname}" do
      source params[:template]
      mode 0600
      owner "root"
      group "root"
      variables(
        :ssh_user => params[:user],
        :ssh_host => hostname,
        :private_key_file => "#{@node[:ssh][:dir]}/#{keyfile}"
      )
      backup false
    end

    # This wipes out the ssh config file, so make sure all configs are placed in config.d
    bash "replace-ssh-config" do
      code "cat #{@node[:ssh][:config_dir]}/* > #{@node[:ssh][:dir]}/config"
    end

  end

  bash "notify-logger" do
    code "logger -t RightScale 'Installed the git SSH Key for root.'"
  end

end
