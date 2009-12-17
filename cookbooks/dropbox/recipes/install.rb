OUTPUT_FILE = "~/dropbox.log"

platform = node[:kernel][:machine]
suffix = (platform == "x86_64") ? platform : "x86"

# This will work in Chef >= 0.7.14
# 
# remote_file "~/dropbox.tar.gz" do
#   source "http://www.getdropbox.com/download?plat=lnx.#{suffix}"
#   mode "0644"
# end
# 
# remote_file "~/dbmakefakelib.py" do
#   source "http://dl.getdropbox.com/u/6995/dbmakefakelib.py"
#   mode "0644"
# end
# 
# remote_file "~/dbreadconfig.py" do
#   source "http://dl.getdropbox.com/u/6995/dbreadconfig.py"
#   mode "0644"
# end

bash "download dropbox" do
  cwd "/root"
  code <<-EOH
    wget -O dropbox.tar.gz http://www.getdropbox.com/download?plat=lnx.#{suffix}
    wget http://dl.getdropbox.com/u/6995/dbmakefakelib.py
    wget http://dl.getdropbox.com/u/6995/dbreadconfig.py
  EOH
end

ruby_block "check download" do
  not_if { ::File.directory?("~/dropbox.tar.gz") }
  block do
    raise "ERROR: unable to download dropbox!"
  end
end

ruby_block "start dropbox" do
   only_if { ::File.directory?("~/dropbox.tar.gz") }
   block do
      `tar zxof dropbox.tar.gz`
   end
end

ruby_block "start dropbox" do
   not_if { ::File.exists?("~/.dropbox-dist/dropboxd") }
   block do
      Kernel.fork { `nohup ~/.dropbox-dist/dropboxd > #{OUTPUT_FILE}` }
      Process.detach # I don't care about my children -- is that wrong?
      Kernel.sleep 10
   end
end
  
    
# bash "install dropbox" do
#   cwd "~"
#   code <<-EOH
#     # Taken from http://wiki.dropbox.com/TipsAndTricks/TextBasedLinuxInstall
#     #
#     wget -O dropbox.tar.gz http://www.getdropbox.com/download?plat=lnx.#{suffix}
#     tar zxof dropbox.tar.gz
#     wget http://dl.getdropbox.com/u/6995/dbmakefakelib.py
#     wget http://dl.getdropbox.com/u/6995/dbreadconfig.py
#     nohup ~/.dropbox-dist/dropboxd > #{OUTPUT_FILE} &
#     echo `cut & paste URL into a browser to register instance.
#     sleep 10
#     cat ~/dropbox-register.log
#   EOH
# end

ruby_block "register instance" do
  block do
    link_line = `grep "link this machine" #{OUTPUT_FILE}`
    words = link_line.split
    url = words[2]
    Chef::Log.info "Registering instance using URL: #{url}"
    `curl #{url}`
  end
end

