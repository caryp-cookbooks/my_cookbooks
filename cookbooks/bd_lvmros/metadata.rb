maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures lvmros block device that can snapshot, backup, and restore itself"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

recipe "bd_lvmros::default", "Installs LVM and create LVMROS resources."
recipe "bd_lvmros::install", "Installs LVM and kernel modules."
recipe "bd_lvmros::setup_remote_storage", "Set up all remote_storage resources that have attributes in the node."
recipe "bd_lvmros::setup_lvm", "Set up all lvmros resources that have attributes in the node."

attribute "remote_storage/default/account/id",
  :display_name => "Remote Storage Account ID",
  :description => "The account ID that will be used to access the 'Remote Storage Container'.  For AWS, enter your AWS Access Key ID.  For Rackspace, enter your username.",
  :required => true

attribute "remote_storage/default/account/credentials",
  :display_name => "Remote Storage Account Key",
  :description => "The account key that will be used to access the 'Remote Storage Container'.  For AWS, enter your AWS Secret Access Key.  For Rackspace, enter your API Key.",
  :required => true
  
attribute "remote_storage/default/container",
  :display_name => "Remote Storage Container",
  :description => "The location, directory, or bucket on the cloud's remote storage service in which files will be stored.  For AWS, enter an S3 bucket name.  For Rackspace, enter the container name.",
  :required => true


