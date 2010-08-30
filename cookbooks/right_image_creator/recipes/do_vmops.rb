include_recipe "right_image_creator::install_vhd-util"

source_image = "#{node.right_image_creator.mount_dir}" 
destination_image = "/mnt/vmops_image"
destination_image_mount = "/mnt/vmops_image_mount"
vhd_image = destination_image + '.vhd'

bash "create_vmops_image" do 
  code <<-EOH
    set -e 
    set -x

    source_image="#{node.right_image_creator.mount_dir}" 
    destination_image="#{destination_image}"
    destination_image_mount="#{destination_image_mount}"

    umount -lf #{source_image}/proc || true 
    umount -lf #{destination_image_mount}/proc || true 
    umount -lf #{destination_image_mount} || true

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
template "#{destination_image_mount}/boot/grub/grub.conf" do 
  source "grub.conf"
  backup false 
end


# add fstab
template "#{destination_image_mount}/etc/fstab" do
  source "fstab.erb"
  backup false
end


bash "do_vmops" do 
  code <<-EOH
#!/bin/bash -ex
    mount_dir=#{destination_image_mount}
    mount -t proc none $mount_dir/proc
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


    umount -lf $mount_dir/proc
    umount -lf $mount_dir
  EOH
end


bash "convert_to_vhd" do 
  cwd File.dirname destination_image
  code <<-EOH
    set -e
    set -x
    
    
    raw_image=$(basename #{destination_image})
    vhd_image=${raw_image}.vhd

    cp $raw_image $raw_image.bak 

    vhd-util convert -s 0 -t 1 -i $raw_image -o $vhd_image
    vhd-util convert -s 1 -t 2 -i $vhd_image -o $vhd_image
    bzip2 $vhd_image

    # upload image
    export AWS_ACCESS_KEY_ID=#{node.right_image_creator.aws_access_key_id_for_upload}
    export AWS_SECRET_ACCESS_KEY=#{node.right_image_creator.aws_secret_access_key_for_upload}
    export AWS_CALLING_FORMAT=SUBDOMAIN 
    /usr/local/bin/s3cmd put #{node.right_image_creator.image_upload_bucket}:#{image_name}.vhd.bz2 /mnt/$vhd_image.bz2 x-amz-acl:public-read

  EOH
end

