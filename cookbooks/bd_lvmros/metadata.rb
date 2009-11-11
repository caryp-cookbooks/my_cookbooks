maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures lvmros block device that can snapshot, backup, and restore itself"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

recipe "bd_lvmros::default", "Installs LVM and create LVMROS resources."
recipe "bd_lvmros::install", "Installs LVM and kernel modules."
recipe "bd_lvmros::setup_remote_storage", "Setup all remote_storage resources that have attributes in the node."
recipe "bd_lvmros::setup_lvm", "Setup all lvmros resources that have attributes in the node."

attribute "remote_storage/default/account/id",
  :display_name => "Remote Storage Account ID",
  :required => true

attribute "remote_storage/default/account/credentials",
  :display_name => "Remote Storage Account Key",
  :required => true
  
attribute "remote_storage/default/container",
  :display_name => "Remote Storage Container",
  :description => "Location, directory, or bucket on the remote storage service in which to store files.",
  :required => true


