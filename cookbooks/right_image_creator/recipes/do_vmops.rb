include_recipe "right_image_creator::install_vhd-util"

source_image = "#{node.rightimage_creator.mount_dir}" 
destination_image = "/mnt/vmops_image"
destination_image_mount = "/mnt/vmops_image_mount"
vhd_image = destination_image + '.vhd'

"#{source_image}/proc #{destination_image_mount}/proc #{destination_image_mount}".split.each do |mount_point|
  mount mount_point do 
    action :umount
  end 
end

bash "create_vmops_image" do 
  code <<-EOH
    set -e 
    set -x

    source_image="#{node.rightimage_creator.mount_dir}" 
    destination_image="#{destination_image}"
    destination_image_mount="#{destination_image_mount}"

    rm -rf $destination_image $destination_image_mount
    dd if=/dev/zero of=$destination_image bs=1M count=10240    
    mke2fs -F -j $destination_image
    mkdir $destination_image_mount
    mount -o loop $destination_image $destination_image_mount
    rsync -a $source_image/ $destination_image_mount/
    mkdir -p $destination_image_mount/boot/grub

  EOH
end

# insert grub conf
template "#{node[:right_image_creator][:mount_dir]}/boot/grub/grub.conf" do 
  source grub.conf
  backup false 
end


# add fstab
template "/mnt/vmops_image_mount/etc/fstab" do
  source "fstab.erb"
  backup false
end

mount "#{destination_image_mount}/proc" do 
  fstype "proc" 
  device "none" 
end


bash "do_vmops" do 
  code <<-EOH
#!/bin/bash -ex
    mount_dir="/mnt/vmops_image_mount/"
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

    mkdir -p $mount_dir/etc/rightscale.d
    echo "vmops" > $mount_dir/etc/rightscale.d/cloud
  EOH
end


"#{destination_image_mount}/proc  #{destination_image_mount}".split.each do |mount_point|
  mount mount_point do 
    action :umount
  end
end

bash "convert_to_vhd" do 
  cwd File.dirname destination_image
  code <<-EOH
    set -e
    set -x
    
    
    raw_image=$(basename #{destination_image})
    vhd_image=${raw_image}.vhd

    vhd-util convert -s 0 -t 1 -i $raw_image -o $vhd_image
    vhd-util convert -s 1 -t 2 -i $vhd_image -o $vhd_image
    bzip2 $vhd_image

    # upload image
    export AWS_ACCESS_KEY_ID=#{node[:right_image_creator][:aws_access_key_id]}
    export AWS_SECRET_ACCESS_KEY=#{node[:right_image_creator][:aws_secret_access_key]}
    s3cmd put rightscale_rightlink_dev:$vhd_image $vhd_image x-amz-acl:public-read

  EOH
end















