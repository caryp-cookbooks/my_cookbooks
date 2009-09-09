# Cookbook Name:: app_rails
# Recipe:: default
#
# Copyright 2009, RightScale, Inc.
#
# All rights reserved - Do Not Redistribute
#
include_recipe "web_apache"
include_recipe "rails"
include_recipe "passenger_apache2::mod_rails"
include_recipe "mysql::client"
include_recipe "repo_git"

# install optional gems required for the application
@node[:rails][:gems_list].each { |gem| gem_package gem } unless "#{@node[:rails][:gems_list]}" == ""

# grab application source from remote repository
include_recipe "app_rails::update_code"

# insert database.yaml
directory "#{@node[:rails][:code][:destination]}/config" do
  recursive true
end
template "#{@node[:rails][:code][:destination]}/config/database.yaml" do
  source "database.yaml.erb"
end

# this should work but chef breaks -- https://tickets.opscode.com/browse/CHEF-205
 #directory @node[:rails][:code][:destination] do
   #owner 'www-data'
   #group 'www-data'
   #mode 0755
   #recursive true
 #end

#we'll just do this for now...

#chown application directory 
bash "chown_home" do
  code <<-EOH
    chown -R www-data:www-data #{@node[:rails][:code][:destination]}
  EOH
end


# setup the passenger vhost
web_app @node[:rails][:application_name] do
  template "passenger_web_app.conf.erb"
  docroot @node[:rails][:code][:destination]
  vhost_port @node[:rails][:application_port]
  server_name @node[:rails][:server_name]
  rails_env @node[:rails][:env]
end

# Move rails logs to /mnt  (TODO:create move definition in rs_tools?)
rails_log = '/mnt/log/rails'
ruby 'move_rails_log' do
  not_if do File.symlink?('/var/log/rails') end
  code <<-EOH
    `rm -rf /var/log/rails`
    `mkdir -p #{rails_log}`
    `ln -s #{rails_log} /var/log/rails`
  EOH
end

# configure logrotate for rails (TODO: create logrotate definition)
template "/etc/logrotate.d/rails" do
  source "logrotate.conf.erb"
  variables(
      :app_name => "rails"
   )    
end

