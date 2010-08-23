## when pasting a key into a json file, make sure to use the following command: 
## sed -e :a -e '$!N;s/\n/\\n/;ta' /path/to/key
## this seems not to work on os x

UNKNOWN = :unknown.to_s

set[:rightimage][:lang] = "en_US.UTF-8"
set[:rightimage][:root_size] = "2048"
set[:rightimage][:build_dir] = "/mnt/vmbuilder"
set[:rightimage][:mount_dir] = "/mnt/image"
set[:rightimage][:virtual_environment] = "xen"
set[:rightimage][:install_mirror] = "mirror.rightscale.com"
set_unless[:rightimage][:image_name_override] = ""

default[:rightimage][:platform] = UNKNOWN
default[:rightimage][:cloud] = "ec2"
default[:rightimage][:release] = UNKNOWN

# set base os packages
case rightimage[:platform]
when "ubuntu" 
  set[:rightimage][:guest_packages] = "ubuntu-standard binutils ruby1.8 curl unzip openssh-server ruby1.8-dev build-essential autoconf automake libtool logrotate rsync openssl openssh-server ca-certificates libopenssl-ruby1.8 subversion vim libreadline-ruby1.8 irb rdoc1.8 git-core liberror-perl libdigest-sha1-perl dmsetup emacs rake screen mailutils nscd bison ncurses-dev zlib1g-dev libreadline5-dev readline-common libxslt1-dev sqlite3 libxml2 flex libshadow-ruby1.8 postfix"

  set[:rightimage][:host_packages] = "apt-proxy openjdk-6-jre openssl ca-certificates"
  set[:rightimage][:package_type] = "deb"
  rightimage[:guest_packages] << " euca2ools" if rightimage[:cloud] == "euca"

when "centos" 
  set[:rightimage][:guest_packages] = "wget mlocate nano logrotate ruby ruby-devel ruby-docs ruby-irb ruby-libs ruby-mode ruby-rdoc ruby-ri ruby-tcltk postfix openssl openssh openssh-askpass openssh-clients openssh-server curl gcc* zip unzip bison flex compat-libstdc++-296 cvs subversion autoconf automake libtool compat-gcc-34-g77 mutt sysstat rpm-build fping vim-common vim-enhanced rrdtool-1.2.27 rrdtool-devel-1.2.27 rrdtool-doc-1.2.27 rrdtool-perl-1.2.27 rrdtool-python-1.2.27 rrdtool-ruby-1.2.27 rrdtool-tcl-1.2.27 pkgconfig lynx screen yum-utils bwm-ng createrepo redhat-rpm-config redhat-lsb git nscd xfsprogs collectd swig"

  rightimage[:guest_packages] << " kernel-xen" if rightimage[:cloud] == "euca"

  set[:rightimage][:host_packages] = "swig"
  set[:rightimage][:package_type] = "rpm"
when UNKNOWN
end

# set addtional release specific packages
case rightimage[:release]
  when "hardy"
    set[:rightimage][:guest_packages] = rightimage[:guest_packages] + " sysv-rc-conf debian-helper-scripts"
    rightimage[:host_packages] << " ubuntu-vm-builder"
  when "karmic"
    rightimage[:guest_packages] << " linux-image-ec2"
    #set[:rightimage][:guest_packages] = rightimage[:guest_packages] + " linux-image-ec2"
    rightimage[:host_packages] << " python-vm-builder-ec2"
  when "lucid"
  if rightimage[:cloud] == "ec2"
    set[:rightimage][:guest_packages] = rightimage[:guest_packages] + " linux-image-2.6.32-305-ec2" 
    rightimage[:host_packages] << " python-vm-builder-ec2"
  else
    set[:rightimage][:guest_packages] = rightimage[:guest_packages] + " linux-image-virtual" 
  end
end if rightimage[:platform] == "ubuntu" 

# set cloud stuff
case rightimage[:cloud]
  when "ec2" 
    set[:rightimage][:root_mount] = "/dev/sda1" 
    set[:rightimage][:ephemeral_mount] = "/dev/sdb" 
    set[:rightimage][:swap_mount] = "/dev/sda3"  unless rightimage[:arch]  == "x86_64"
end

# set rightscale stuff
set_unless[:rightimage][:rightscale_release] = ""
set_unless[:rightimage][:aws_access_key_id] = nil
set_unless[:rightimage][:aws_secret_access_key] = nil

# generate command to install getsshkey init script 
case rightimage[:platform]
  when "ubuntu" 
    set[:rightimage][:getsshkey_cmd] = "chroot #{rightimage[:mount_dir]} update-rc.d getsshkey start 20 2 3 4 5 . stop 1 0 1 6 ."
    set[:rightimage][:mirror_file] = "sources.list.erb"
    set[:rightimage][:mirror_file_path] = "/etc/apt/sources.list"
  when "centos"
    set[:rightimage][:getsshkey_cmd] = "chroot #{rightimage[:mount_dir]} chkconfig --add getsshkey && \
               chroot #{rightimage[:mount_dir]} chkconfig --level 4 getsshkey on"
    set[:rightimage][:mirror_file] = "CentOS.repo.erb"
    set[:rightimage][:mirror_file_path] = "/etc/yum.repos.d/CentOS.repo"
  when UNKNOWN

end

# set default mirrors and EC2 endpoint
case rightimage[:region]
  when "us-east"
    set[:rightimage][:mirror] = "http://ec2-us-east-mirror.rightscale.com"
    set[:rightimage][:ec2_endpoint] = "https://ec2.us-east-1.amazonaws.com"
  when "us-west"
    set[:rightimage][:mirror] = "http://ec2-us-west-mirror.rightscale.com"
    set[:rightimage][:ec2_endpoint] = "https://ec2.us-west-1.amazonaws.com"
  when "eu-west"
    set[:rightimage][:mirror] = "http://ec2-eu-west-mirror.rightscale.com"
    set[:rightimage][:ec2_endpoint] = "https://ec2.eu-west-1.amazonaws.com"
  when "ap-southeast"
    set[:rightimage][:mirror] = "http://ec2-ap-southeast-mirror.rightscale.com"
    set[:rightimage][:ec2_endpoint] = "https://ec2.ap-southeast-1.amazonaws.com"
  else
    set[:rightimage][:mirror] = "http://mirror.rightscale.com"
    set[:rightimage][:ec2_endpoint] = "https://ec2.us-east-1.amazonaws.com"
end #if rightimage[:cloud] == "ec2" 

# if ubuntu then figure out the numbered name
case rightimage[:release]
  when "hardy" 
    set[:rightimage][:release_number] = "8.04"
  when "intrepid" 
    set[:rightimage][:release_number] = "8.10"
  when "jaunty" 
    set[:rightimage][:release_number] = "9.04"
  when "karmic" 
    set[:rightimage][:release_number] = "9.10"
  when "lucid" 
    set[:rightimage][:release_number] = "10.04"
  when "maverick" 
    set[:rightimage][:release_number] = "10.10" 
  else 
    set[:rightimage][:release_number] = rightimage[:release]
end

## figure out kernel to use
case rightimage[:release]
when UNKNOWN
when "hardy"
  case rightimage[:region]
  when "us-east"
    case rightimage[:arch]
    when "i386" 
      set[:rightimage][:kernel_id] = "aki-a71cf9ce"
      set[:rightimage][:ramdisk_id] = "ari-a51cf9cc"
    when "x86_64"
      set[:rightimage][:kernel_id] = "aki-b51cf9dc"
      set[:rightimage][:ramdisk_id] = "ari-b31cf9da"
    end
  when "us-west"
    case rightimage[:arch]
    when "i386" 
      set[:rightimage][:kernel_id] = "aki-873667c2"
      set[:rightimage][:ramdisk_id] = "ari-853667c0"
    when "x86_64"
      set[:rightimage][:kernel_id] = "aki-813667c4"
      set[:rightimage][:ramdisk_id] = "ari-833667c6"
    end
  when "eu-west" 
    case rightimage[:arch]
    when "i386" 
      set[:rightimage][:kernel_id] = "aki-7e0d250a"
      set[:rightimage][:ramdisk_id] = "ari-7d0d2509"
    when "x86_64"
      set[:rightimage][:kernel_id] = "aki-780d250c"
      set[:rightimage][:ramdisk_id] = "ari-7f0d250b"
    end
  when "ap-southeast"
    case rightimage[:arch]
    when "i386" 
      set[:rightimage][:kernel_id] = "aki-15f58a47"
      set[:rightimage][:ramdisk_id] = "ari-37f58a65"
    when "x86_64"
      set[:rightimage][:kernel_id] = "aki-1df58a4f"
      set[:rightimage][:ramdisk_id] = "ari-35f58a67"
    end
  end
when "karmic"
  case rightimage[:region]
  when "us-east"
    case rightimage[:arch]
    when "i386" 
      set[:rightimage][:kernel_id] = "aki-5f15f636"
      set[:rightimage][:ramdisk_id] = "ari-d5709dbc"
    when "x86_64"
      set[:rightimage][:kernel_id] = "aki-fd15f694"
      set[:rightimage][:ramdisk_id] = "ari-c515f6ac"
    end
  when "us-west"
    case rightimage[:arch]
    when "i386" 
      set[:rightimage][:kernel_id] = "aki-733c6d36"
      set[:rightimage][:ramdisk_id] = "ari-632e7f26"
    when "x86_64"
      set[:rightimage][:kernel_id] = "aki-033c6d46"
      set[:rightimage][:ramdisk_id] = "ari-793c6d3c"
    end
  when "eu-west" 
    case rightimage[:arch]
    when "i386" 
      set[:rightimage][:kernel_id] = "aki-0c5e7578"
      set[:rightimage][:ramdisk_id] = "ari-39c2e94d"
    when "x86_64"
      set[:rightimage][:kernel_id] = "aki-a22a01d6"
      set[:rightimage][:ramdisk_id] = "ari-ac2a01d8"
    end
  when "ap-southeast"
    case rightimage[:arch]
    when "i386" 
      set[:rightimage][:kernel_id] = "aki-87f38cd5"
      set[:rightimage][:ramdisk_id] = "ari-85f38cd7"
    when "x86_64"
      set[:rightimage][:kernel_id] = "aki-83f38cd1"
      set[:rightimage][:ramdisk_id] = "ari-81f38cd3"
    end
  end
when "lucid"
  case rightimage[:region]
  when "us-east"
    case rightimage[:arch]
    when "i386" 
      set[:rightimage][:kernel_id] = "aki-754aa41c"
      set[:rightimage][:ramdisk_id] = nil
    when "x86_64"
      set[:rightimage][:kernel_id] = "aki-0b4aa462"
      set[:rightimage][:ramdisk_id] = nil
    end
  when "us-west"
    case rightimage[:arch]
    when "i386" 
      set[:rightimage][:kernel_id] = "aki-3197c674"
      set[:rightimage][:ramdisk_id] = nil
    when "x86_64"
      set[:rightimage][:kernel_id] = "aki-c397c686"
      set[:rightimage][:ramdisk_id] = nil
    end
  when "eu-west" 
    case rightimage[:arch]
    when "i386" 
      set[:rightimage][:kernel_id] = "aki-c34d67b7"
      set[:rightimage][:ramdisk_id] = nil
    when "x86_64"
      set[:rightimage][:kernel_id] = "aki-cb4d67bf"
      set[:rightimage][:ramdisk_id] = nil
    end
  when "ap-southeast"
    case rightimage[:arch]
    when "i386" 
      set[:rightimage][:kernel_id] = "aki-bdf38cef"
      set[:rightimage][:ramdisk_id] = nil
    when "x86_64"
      set[:rightimage][:kernel_id] = "aki-a9f38cfb"
      set[:rightimage][:ramdisk_id] = nil
    end
  end
when "5.4"
  case rightimage[:region]
  when "us-east"
    case rightimage[:arch]
    when "i386" 
      set[:rightimage][:kernel_id] = "aki-a71cf9ce"
      set[:rightimage][:ramdisk_id] = "ari-a51cf9cc"
    when "x86_64"
      set[:rightimage][:kernel_id] = "aki-b51cf9dc"
      set[:rightimage][:ramdisk_id] = "ari-b31cf9da"
    end
  when "us-west"
    case rightimage[:arch]
    when "i386" 
      set[:rightimage][:kernel_id] = "aki-873667c2"
      set[:rightimage][:ramdisk_id] = "ari-853667c0"
    when "x86_64"
      set[:rightimage][:kernel_id] = "aki-813667c4"
      set[:rightimage][:ramdisk_id] = "ari-833667c6"
    end
  when "eu-west"
    case rightimage[:arch]
    when "i386" 
      set[:rightimage][:kernel_id] = "aki-7e0d250a"
      set[:rightimage][:ramdisk_id] = "ari-7d0d2509"
    when "x86_64"
      set[:rightimage][:kernel_id] = "aki-780d250c"
      set[:rightimage][:ramdisk_id] = "ari-7f0d250b"
    end
  when "ap-southeast"
    case rightimage[:arch]
    when "i386" 
      set[:rightimage][:kernel_id] = "aki-15f58a47"
      set[:rightimage][:ramdisk_id] = "ari-37f58a65"
    when "x86_64"
      set[:rightimage][:kernel_id] = "aki-1df58a4f"
      set[:rightimage][:ramdisk_id] = "ari-35f58a67"
    end
  end
end
