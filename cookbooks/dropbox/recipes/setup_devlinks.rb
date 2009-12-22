# this script sets up the development environment with links to your dropbox
# PATHs expected are /root/Dropbox/projects/your git repository && right_resources_premium

ruby_block "setup custom devlinks for faster development with dropbox" do
  block do
    require 'fileutils'

    # wait for dropbox
    while(1)
      if `dropbox filestatus /root/Dropbox/projects` =~ /up to date/
        break
        Chef::Log.info "waiting for dropbox to sync /root/Dropbox/projects"
        sleep 1
      end
    end
    
    # cookbook links
    cb = Dir.glob("/var/cache/rightscale/cookbooks/*")
    cb.each do |book|
      book =~ /_([a-zA-Z]+?_[a-zA-Z]+?)_git/
      shortname = $1
      unless book.nil?
        src = "/root/Dropbox/#{shortname}"
        Chef::Log.info "deleting #{book}"
        FileUtils.rm_rf(book)
        Chef::Log.info "relinking #{book} to dropbox at #{src}"
        File.symlink(src, book)
      end 
    end

    # right_resources_premium gem link
    res_gemfile = Dir.glob("/opt/rightscale/sandbox/lib/ruby/gems/1.8/gems/right_resources_premium*").first
    unless res_gemfile.nil?
      src = "/root/Dropbox/right_resources_premium"
      puts "deleting #{res_gemfile}"
      FileUtils.rm_rf(res_gemfile)
      puts "relinking #{res_gemfile} dropbox at #{src}"
      File.symlink(src, res_gemfile)
    end
  end
end

template "/tmp/disable_cook.sh" do
  source "disable_cook.sh.erb"
  owner "root"
  mode "755"
end 

ruby_block "run disable cook background" do
  block do
    `/tmp/disable_cook.sh &`
  end
end
