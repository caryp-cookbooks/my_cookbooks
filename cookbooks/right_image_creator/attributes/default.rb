## when pasting a key into a json file, make sure to use the following command: 
## sed -e :a -e '$!N;s/\n/\\n/;ta' /path/to/key
## this seems not to work on os x

UNKNOWN = :unknown.to_s

set[:right_image_creator][:lang] = "en_US.UTF-8"
set[:right_image_creator][:root_size] = "2048"
set[:right_image_creator][:build_dir] = "/mnt/vmbuilder"
set[:right_image_creator][:mount_dir] = "/mnt/image"
set[:right_image_creator][:virtual_environment] = "xen"
set[:right_image_creator][:install_mirror] = "mirror.rightscale.com"
set_unless[:right_image_creator][:image_name_override] = ""

default[:right_image_creator][:platform] = UNKNOWN
default[:right_image_creator][:cloud] = "ec2"
default[:right_image_creator][:release] = UNKNOWN

# set base os packages
case right_image_creator[:platform]
when "ubuntu" 
  set[:right_image_creator][:guest_packages] = "ubuntu-standard binutils ruby1.8 curl unzip openssh-server ruby1.8-dev build-essential autoconf automake libtool logrotate rsync openssl openssh-server ca-certificates libopenssl-ruby1.8 subversion vim libreadline-ruby1.8 irb rdoc1.8 git-core liberror-perl libdigest-sha1-perl dmsetup emacs rake screen mailutils nscd bison ncurses-dev zlib1g-dev libreadline5-dev readline-common libxslt1-dev sqlite3 libxml2 flex libshadow-ruby1.8 postfix"

  set[:right_image_creator][:host_packages] = "apt-proxy openjdk-6-jre openssl ca-certificates"
  set[:right_image_creator][:package_type] = "deb"
  right_image_creator[:guest_packages] << " euca2ools" if right_image_creator[:cloud] == "euca"

when "centos" 
  set[:right_image_creator][:guest_packages] = "wget mlocate nano logrotate ruby ruby-devel ruby-docs ruby-irb ruby-libs ruby-mode ruby-rdoc ruby-ri ruby-tcltk postfix openssl openssh openssh-askpass openssh-clients openssh-server curl gcc* zip unzip bison flex compat-libstdc++-296 cvs subversion autoconf automake libtool compat-gcc-34-g77 mutt sysstat rpm-build fping vim-common vim-enhanced rrdtool-1.2.27 rrdtool-devel-1.2.27 rrdtool-doc-1.2.27 rrdtool-perl-1.2.27 rrdtool-python-1.2.27 rrdtool-ruby-1.2.27 rrdtool-tcl-1.2.27 pkgconfig lynx screen yum-utils bwm-ng createrepo redhat-rpm-config redhat-lsb git nscd xfsprogs collectd swig"

  right_image_creator[:guest_packages] << " kernel-xen" if right_image_creator[:cloud] == "euca"

  set[:right_image_creator][:host_packages] = "swig"
  set[:right_image_creator][:package_type] = "rpm"
when UNKNOWN
end

# set addtional release specific packages
case right_image_creator[:release]
  when "hardy"
    set[:right_image_creator][:guest_packages] = right_image_creator[:guest_packages] + " sysv-rc-conf debian-helper-scripts"
    right_image_creator[:host_packages] << " ubuntu-vm-builder"
  when "karmic"
    right_image_creator[:guest_packages] << " linux-image-ec2"
    #set[:right_image_creator][:guest_packages] = right_image_creator[:guest_packages] + " linux-image-ec2"
    right_image_creator[:host_packages] << " python-vm-builder-ec2"
  when "lucid"
  if right_image_creator[:cloud] == "ec2"
    set[:right_image_creator][:guest_packages] = right_image_creator[:guest_packages] + " linux-image-2.6.32-305-ec2" 
    right_image_creator[:host_packages] << " python-vm-builder-ec2"
  else
    set[:right_image_creator][:guest_packages] = right_image_creator[:guest_packages] + " linux-image-virtual" 
  end
end if right_image_creator[:platform] == "ubuntu" 

# set cloud stuff
case right_image_creator[:cloud]
  when "ec2" 
    set[:right_image_creator][:root_mount] = "/dev/sda1" 
    set[:right_image_creator][:ephemeral_mount] = "/dev/sdb" 
    set[:right_image_creator][:swap_mount] = "/dev/sda3"  unless right_image_creator[:arch]  == "x86_64"
  when "vmops"
    set[:right_image_creator][:root_mount] = "/dev/xvda"
    set[:right_image_creator][:ephemeral_mount] = "/dev/xvdb"
end

# set rightscale stuff
set_unless[:right_image_creator][:rightscale_release] = ""
set_unless[:right_image_creator][:aws_access_key_id] = nil
set_unless[:right_image_creator][:aws_secret_access_key] = nil

# generate command to install getsshkey init script 
case right_image_creator[:platform]
  when "ubuntu" 
    set[:right_image_creator][:getsshkey_cmd] = "chroot #{right_image_creator[:mount_dir]} update-rc.d getsshkey start 20 2 3 4 5 . stop 1 0 1 6 ."
    set[:right_image_creator][:mirror_file] = "sources.list.erb"
    set[:right_image_creator][:mirror_file_path] = "/etc/apt/sources.list"
  when "centos"
    set[:right_image_creator][:getsshkey_cmd] = "chroot #{right_image_creator[:mount_dir]} chkconfig --add getsshkey && \
               chroot #{right_image_creator[:mount_dir]} chkconfig --level 4 getsshkey on"
    set[:right_image_creator][:mirror_file] = "CentOS.repo.erb"
    set[:right_image_creator][:mirror_file_path] = "/etc/yum.repos.d/CentOS.repo"
  when UNKNOWN

end

# set default mirrors and EC2 endpoint
case right_image_creator[:region]
  when "us-east"
    set[:right_image_creator][:mirror] = "http://ec2-us-east-mirror.rightscale.com"
    set[:right_image_creator][:ec2_endpoint] = "https://ec2.us-east-1.amazonaws.com"
  when "us-west"
    set[:right_image_creator][:mirror] = "http://ec2-us-west-mirror.rightscale.com"
    set[:right_image_creator][:ec2_endpoint] = "https://ec2.us-west-1.amazonaws.com"
  when "eu-west"
    set[:right_image_creator][:mirror] = "http://ec2-eu-west-mirror.rightscale.com"
    set[:right_image_creator][:ec2_endpoint] = "https://ec2.eu-west-1.amazonaws.com"
  when "ap-southeast"
    set[:right_image_creator][:mirror] = "http://ec2-ap-southeast-mirror.rightscale.com"
    set[:right_image_creator][:ec2_endpoint] = "https://ec2.ap-southeast-1.amazonaws.com"
  else
    set[:right_image_creator][:mirror] = "http://mirror.rightscale.com"
    set[:right_image_creator][:ec2_endpoint] = "https://ec2.us-east-1.amazonaws.com"
end #if right_image_creator[:cloud] == "ec2" 

# if ubuntu then figure out the numbered name
case right_image_creator[:release]
  when "hardy" 
    set[:right_image_creator][:release_number] = "8.04"
  when "intrepid" 
    set[:right_image_creator][:release_number] = "8.10"
  when "jaunty" 
    set[:right_image_creator][:release_number] = "9.04"
  when "karmic" 
    set[:right_image_creator][:release_number] = "9.10"
  when "lucid" 
    set[:right_image_creator][:release_number] = "10.04"
  when "maverick" 
    set[:right_image_creator][:release_number] = "10.10" 
  else 
    set[:right_image_creator][:release_number] = right_image_creator[:release]
end

## figure out kernel to use
case right_image_creator[:release]
when UNKNOWN
when "hardy"
  case right_image_creator[:region]
  when "us-east"
    case right_image_creator[:arch]
    when "i386" 
      set[:right_image_creator][:kernel_id] = "aki-a71cf9ce"
      set[:right_image_creator][:ramdisk_id] = "ari-a51cf9cc"
    when "x86_64"
      set[:right_image_creator][:kernel_id] = "aki-b51cf9dc"
      set[:right_image_creator][:ramdisk_id] = "ari-b31cf9da"
    end
  when "us-west"
    case right_image_creator[:arch]
    when "i386" 
      set[:right_image_creator][:kernel_id] = "aki-873667c2"
      set[:right_image_creator][:ramdisk_id] = "ari-853667c0"
    when "x86_64"
      set[:right_image_creator][:kernel_id] = "aki-813667c4"
      set[:right_image_creator][:ramdisk_id] = "ari-833667c6"
    end
  when "eu-west" 
    case right_image_creator[:arch]
    when "i386" 
      set[:right_image_creator][:kernel_id] = "aki-7e0d250a"
      set[:right_image_creator][:ramdisk_id] = "ari-7d0d2509"
    when "x86_64"
      set[:right_image_creator][:kernel_id] = "aki-780d250c"
      set[:right_image_creator][:ramdisk_id] = "ari-7f0d250b"
    end
  when "ap-southeast"
    case right_image_creator[:arch]
    when "i386" 
      set[:right_image_creator][:kernel_id] = "aki-15f58a47"
      set[:right_image_creator][:ramdisk_id] = "ari-37f58a65"
    when "x86_64"
      set[:right_image_creator][:kernel_id] = "aki-1df58a4f"
      set[:right_image_creator][:ramdisk_id] = "ari-35f58a67"
    end
  end
when "karmic"
  case right_image_creator[:region]
  when "us-east"
    case right_image_creator[:arch]
    when "i386" 
      set[:right_image_creator][:kernel_id] = "aki-5f15f636"
      set[:right_image_creator][:ramdisk_id] = "ari-d5709dbc"
    when "x86_64"
      set[:right_image_creator][:kernel_id] = "aki-fd15f694"
      set[:right_image_creator][:ramdisk_id] = "ari-c515f6ac"
    end
  when "us-west"
    case right_image_creator[:arch]
    when "i386" 
      set[:right_image_creator][:kernel_id] = "aki-733c6d36"
      set[:right_image_creator][:ramdisk_id] = "ari-632e7f26"
    when "x86_64"
      set[:right_image_creator][:kernel_id] = "aki-033c6d46"
      set[:right_image_creator][:ramdisk_id] = "ari-793c6d3c"
    end
  when "eu-west" 
    case right_image_creator[:arch]
    when "i386" 
      set[:right_image_creator][:kernel_id] = "aki-0c5e7578"
      set[:right_image_creator][:ramdisk_id] = "ari-39c2e94d"
    when "x86_64"
      set[:right_image_creator][:kernel_id] = "aki-a22a01d6"
      set[:right_image_creator][:ramdisk_id] = "ari-ac2a01d8"
    end
  when "ap-southeast"
    case right_image_creator[:arch]
    when "i386" 
      set[:right_image_creator][:kernel_id] = "aki-87f38cd5"
      set[:right_image_creator][:ramdisk_id] = "ari-85f38cd7"
    when "x86_64"
      set[:right_image_creator][:kernel_id] = "aki-83f38cd1"
      set[:right_image_creator][:ramdisk_id] = "ari-81f38cd3"
    end
  end
when "lucid"
  case right_image_creator[:region]
  when "us-east"
    case right_image_creator[:arch]
    when "i386" 
      set[:right_image_creator][:kernel_id] = "aki-754aa41c"
      set[:right_image_creator][:ramdisk_id] = nil
    when "x86_64"
      set[:right_image_creator][:kernel_id] = "aki-0b4aa462"
      set[:right_image_creator][:ramdisk_id] = nil
    end
  when "us-west"
    case right_image_creator[:arch]
    when "i386" 
      set[:right_image_creator][:kernel_id] = "aki-3197c674"
      set[:right_image_creator][:ramdisk_id] = nil
    when "x86_64"
      set[:right_image_creator][:kernel_id] = "aki-c397c686"
      set[:right_image_creator][:ramdisk_id] = nil
    end
  when "eu-west" 
    case right_image_creator[:arch]
    when "i386" 
      set[:right_image_creator][:kernel_id] = "aki-c34d67b7"
      set[:right_image_creator][:ramdisk_id] = nil
    when "x86_64"
      set[:right_image_creator][:kernel_id] = "aki-cb4d67bf"
      set[:right_image_creator][:ramdisk_id] = nil
    end
  when "ap-southeast"
    case right_image_creator[:arch]
    when "i386" 
      set[:right_image_creator][:kernel_id] = "aki-bdf38cef"
      set[:right_image_creator][:ramdisk_id] = nil
    when "x86_64"
      set[:right_image_creator][:kernel_id] = "aki-a9f38cfb"
      set[:right_image_creator][:ramdisk_id] = nil
    end
  end
when "5.4"
  case right_image_creator[:region]
  when "us-east"
    case right_image_creator[:arch]
    when "i386" 
      set[:right_image_creator][:kernel_id] = "aki-a71cf9ce"
      set[:right_image_creator][:ramdisk_id] = "ari-a51cf9cc"
    when "x86_64"
      set[:right_image_creator][:kernel_id] = "aki-b51cf9dc"
      set[:right_image_creator][:ramdisk_id] = "ari-b31cf9da"
    end
  when "us-west"
    case right_image_creator[:arch]
    when "i386" 
      set[:right_image_creator][:kernel_id] = "aki-873667c2"
      set[:right_image_creator][:ramdisk_id] = "ari-853667c0"
    when "x86_64"
      set[:right_image_creator][:kernel_id] = "aki-813667c4"
      set[:right_image_creator][:ramdisk_id] = "ari-833667c6"
    end
  when "eu-west"
    case right_image_creator[:arch]
    when "i386" 
      set[:right_image_creator][:kernel_id] = "aki-7e0d250a"
      set[:right_image_creator][:ramdisk_id] = "ari-7d0d2509"
    when "x86_64"
      set[:right_image_creator][:kernel_id] = "aki-780d250c"
      set[:right_image_creator][:ramdisk_id] = "ari-7f0d250b"
    end
  when "ap-southeast"
    case right_image_creator[:arch]
    when "i386" 
      set[:right_image_creator][:kernel_id] = "aki-15f58a47"
      set[:right_image_creator][:ramdisk_id] = "ari-37f58a65"
    when "x86_64"
      set[:right_image_creator][:kernel_id] = "aki-1df58a4f"
      set[:right_image_creator][:ramdisk_id] = "ari-35f58a67"
    end
  end
end

## set kernel to use for vmops
case right_image_creator[:release]
when "5.2" 
  set.right_image_creator.vmops.kernel = "2.6.18-92.1.22.el5.centos.plusxen"
when "5.4" 
  set.right_image_creator.vmops.kernel = "2.6.18-164.15.1.el5.centos.plusxen"
end
