include_recipe "web_apache"
include_recipe "rails"
include_recipe "passenger_apache2::mod_rails"
include_recipe "repo_git"

# grab application source from remote repository
repo_git_pull "Get Repository" do
  url @node[:rails][:code][:url]
  branch @node[:rails][:code][:branch]
  user @node[:rails][:code][:user]
  dest @node[:rails][:code][:destination]
  cred @node[:rails][:code][:credentials]
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

