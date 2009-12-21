OUTPUT_FILE = "dropbox.log"
DROPBOX_EXEC = "/root/.dropbox-dist/dropboxd"

platform = node[:kernel][:machine]
suffix = (platform == "x86_64") ? platform : "x86"

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
      # Process.kill("HUP", pid)
      # Process.wait
   end
end

ruby_block "register instance" do
  only_if do ::File.exists?("/root/#{OUTPUT_FILE}") end
  block do
    
    data = "--data-urlencode login_email=#{node[:dropbox][:email]} "
    data << "--data-urlencode login_password=#{node[:dropbox][:password]} "
    data << "-d 'login_submit=Log in' "
    data << "-d remember_me=on "
    data << "-d t=791206fc33 "

    link_line = `grep "link this machine" /root/#{OUTPUT_FILE}`
    words = link_line.split
    url = words[2]
    data << "-d cont=#{url}"
    
    Chef::Log.info "Registering instance using URL: #{url}"
    cmd = "curl -L -c cookies.txt #{data} -o /root/dropbox_register.log --url https://www.dropbox.com/login"
    Chef::Log.info "Running command: #{cmd}"
    `cmd`
  end
end

