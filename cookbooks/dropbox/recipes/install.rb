bash "install dropbox" do
  code<<-EOH
    # Taken from http://wiki.dropbox.com/TipsAndTricks/TextBasedLinuxInstall
    #
    cd ~
    platform=`uname -m` 
    http://www.getdropbox.com/download?plat=lnx.$platform
    wget -O dropbox.tar.gz http://www.getdropbox.com/download?plat=lnx.x86
    tar zxof dropbox.tar.gz
    wget http://dl.getdropbox.com/u/6995/dbmakefakelib.py
    wget http://dl.getdropbox.com/u/6995/dbreadconfig.py
    ~/.dropbox-dist/dropboxd > ~/dropbox-register.log &
    echo cut & paste URL into a browser to register instance.
    sleep 10
    echo `cat ~/dropbox-register.log`
  EOH
end