OUTPUT_FILE = "dropbox.log"
DROPBOX_EXEC = "/root/.dropbox-dist/dropboxd"

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
    tar zxof dropbox.tar.gz
  EOH
end

bash "download CLI tool" do
  cwd "/root"
  code <<-EOH
    wget -P /usr/local/bin http://www.dropbox.com/download?dl=packages/dropbox.py
    mv /usr/local/bin/dropbox.py /usr/local/bin/dropbox
    chmod 755 /usr/local/bin/dropbox
    /usr/local/bin/dropbox help
  EOH
end

ruby_block "check download" do
  not_if do ::File.exists?(DROPBOX_EXEC) end
  block do
    raise "ERROR: unable to download dropbox!"
  end
end

ruby_block "start dropbox" do
   only_if do ::File.exists?(DROPBOX_EXEC) end
   block do
      pid = Kernel.fork { `nohup /root/.dropbox-dist/dropboxd > /root/#{OUTPUT_FILE}` }
      Process.detach(pid) # I don't care about my child -- is that wrong?
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
#     nohup ~/.dropbox-dist/dropboxd > ~/#{OUTPUT_FILE} &
#     echo `cut & paste URL into a browser to register instance.
#     sleep 10
#     cat ~/dropbox-register.log
#   EOH
# end

# ruby_block "login to dropbox" do
#   block do
#      `curl -L -c cookies.txt -d t=791206fc33 -d login_email=#{node[:dropbox][:email]} -d login_password=#{node[:dropbox][:password]} -o /root/dropbox_login.log --url https://www.dropbox.com/login`
#   end
# end

ruby_block "register instance" do
  only_if do ::File.exists?("/root/#{OUTPUT_FILE}") end
  block do
    
    data = "login_email=#{node[:dropbox][:email]}"
    data << "&login_password=#{node[:dropbox][:password]}"
    data << "&login_submit=Log in"
    data << "&remember_me=on"
    data << "&t=791206fc33"

    link_line = `grep "link this machine" /root/#{OUTPUT_FILE}`
    words = link_line.split
    url = words[2]
    data << "&cont=#{url}"
    #encoded_data = data.gsub(/[^a-zA-Z0-9_\.\-]/n) { sprintf('%%%02x', $&[0]) }
    
    Chef::Log.info "Registering instance using URL: #{url}"
    `curl -L -c cookies.txt --data-urlencode #{data} -o /root/dropbox_register.log --url #{url}`
  end
end

