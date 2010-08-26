xenserver_ip = 1.2.3.4

node[:right_image_creator] = "vmops" 



#  - add fstab
template "#{node[:right_image_creator][:mount_dir]}/etc/fstab" do
  source "fstab.erb"
  backup false
end


bash "do_vmops" do 
  code <<-EOH
#!/bin/bash -ex
    mount_dir="#{node[:right_image_creator][:mount_dir]}"
    rm -f $mount_dir/boot/vmlinu* 
    yum -c /tmp/yum.conf --installroot=$mount_dir -y install kernel-xen
    rm -f $mount_dir/boot/initrd*
    chroot $mount_dir mkinitrd --omit-scsi-modules --with=xennet  --preload=xenblk  initrd-2.6.18-164.15.1.el5.centos.plusxen  2.6.18-164.15.1.el5.centos.plusxen
    mv $mount_dir/initrd-2.6.18-164.15.1.el5.centos.plusxen  $mount_dir/boot/.

    # clear out unnecessary modules
    rm -rf $mount_dir/lib/modules/2.6.24-19-xen
    rm -rf $mount_dir/lib/modules/2.6.18-164.15.1.el5.centos.plus

    # clean out packages
    yum -c /tmp/yum.conf --installroot=$mount_dir -y clean all

    # enable console access
    echo "2:2345:respawn:/sbin/mingetty xvc0" >> $mount_dir/etc/inittab
    echo "xvc0" >> $mount_dir/etc/securetty

    mkdir -p $mount_dir/boot/grub

  EOH
end

template "#{node[:right_image_creator][:mount_dir]}/boot/grub/grub.conf" do 
  source grub.conf
  backup false 
end
