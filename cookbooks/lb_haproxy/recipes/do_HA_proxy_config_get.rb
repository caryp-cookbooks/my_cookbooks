#
# Copyright (c) 2007-2009 RightScale, Inc, All Rights Reserved Worldwide.
#
# Contacts an HAProxy server to get config file

# LB_HOSTNAME -- DNS name of the front ends
ruby_block "Legacy get haproxy config" do
  block do

    require 'resolv'
    
    cfg_file="/home/haproxy/rightscale_lb.cfg"
    
    # Connect to a running instances of the lb host to get config
    addrs = Resolv.getaddresses("#{@node[:lb_haproxy][:host]}")
    puts "Found  #{addrs.length} addresses for host #{@node[:lb_haproxy][:host]}"
    exit(-1) if addrs.length == 0 
    
    addrs.each do |addr| 
      # we don't want our own config
      next if addr == "#{@node[:cloud][:public_ip]}" || 
              addr == "#{@node[:cloud][:private_ip]}" || 
              addr == "localhost" || 
              addr == "127.0.0.1"
puts `logger "ADDR: #{addr}"`    
      puts ">>>>>>>Getting config from host #{addr} <<<<<<<<<<<<<<"
      sshcmd = "ssh -o StrictHostKeyChecking=no -o PasswordAuthentication=no root@#{addr}"
      new_config=""
      30.times {
        #get config from host
        new_config=`#{sshcmd} cat #{cfg_file}`
        break if $? == 0
        sleep 1
      }
puts `logger "GOT CONFIG #{new_config}"`
      if $? != 0
        puts "Error getting config file from host #{addr}"
        next
      end
    
      my_config = File.open(cfg_file,"r+")
      my_config.truncate(0)
      my_config.write(new_config)
      my_config.close
    
      res = `service haproxy restart`
      if $? == 0
        puts "#{res}\nService restarted successfully."
puts `logger "restart success"`
        exit 0
      else
        puts "#{res}\nCould not restart HAProxy!!!"
puts `logger "restart fail"`
        exit(-1)
      end
    end
    
puts `logger "Could not get config file"`
    puts "Could not get a config file!!!"
    puts "Are you using the correct LB_HOSTNAME parameter?...  Do you have another LB up?"
    exit(-1)
  
  end
end
