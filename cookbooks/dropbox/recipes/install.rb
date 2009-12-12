OUTPUT_FILE = "~/dropbox.log"

bash "install dropbox" do
  code <<-EOH
    # Taken from http://wiki.dropbox.com/TipsAndTricks/TextBasedLinuxInstall
    #
    cd ~
    platform=`uname -m` 
    wget -O dropbox.tar.gz http://www.getdropbox.com/download?plat=lnx.$platform
    tar zxof dropbox.tar.gz
    wget http://dl.getdropbox.com/u/6995/dbmakefakelib.py
    wget http://dl.getdropbox.com/u/6995/dbreadconfig.py
    ~/.dropbox-dist/dropboxd > #{OUTPUT_FILE} &
    echo `cut & paste URL into a browser to register instance.
    sleep 10
    cat ~/dropbox-register.log
  EOH
end

ruby_bock "register instance" do
  block do
    link_line = `grep "link this machine" #{OUTPUT_FILE}`
    words = link_line.split
    url = words[2]
    Chef::Log.info "Registering instance using URL: #{url}"
    `curl #{url}`
  end
end

