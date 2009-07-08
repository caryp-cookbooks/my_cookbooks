
# include the public recipe for basic installation
include_recipe "apache2"

## Move Apache
content_dir = '/mnt/www'
ruby 'move_apache' do
  not_if do File.directory?(content_dir) end
  code <<-EOH
    `mkdir -p #{content_dir}`
    `cp -rf /var/www/. #{content_dir}`
    `rm -rf /var/www`
    `ln -nsf #{content_dir} /var/www`
  EOH
end

## Move Apache Logs
apache_name = @node[:apache][:dir].split("/").last
ruby 'move_apache_logs' do
  not_if do File.symlink?(@node[:apache][:log_dir]) end
  code <<-EOH
    `rm -rf #{@node[:apache][:log_dir]}`
    `mkdir -p /mnt/log/#{apache_name}`
    `ln -s /mnt/log/#{apache_name} #{@node[:apache][:log_dir]}`
  EOH
end

# Configuring Apache Multi-Processing Module
case node[:platform]
  when "centos","redhat","fedora","suse"

    binary_to_use = @node[:apache][:binary]
    if @node[:apache][:mpm] != 'prefork'
      binary_to_use << ".worker"
    end

    template "/etc/sysconfig/httpd" do
      source "sysconfig_httpd.erb"
      mode "0644"
      variables(
        :sysconfig_httpd => binary_to_use
      )
      notifies :reload, resources(:service => "apache2")
    end
  when "debian","ubuntu"
    package "apache2-mpm-#{node[:apache][:mpm]}"
end

ruby "log_stat" do
  code "puts('Started the apache server.')"
end

