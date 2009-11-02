maintainer        "RightScale, Inc."
maintainer_email  "cookbooks@rightscale.com"
license           "Copyright (c) 2009 RightScale, Inc, All Rights Reserved Worldwide."
description       "installs the openssh connectivity tools"
version           "0.1"

recipe            "auth_ssh::add_cred", "add ssh private key and config for use with a given host (if host specified)"

attribute "auth_ssh",
  :display_name => "SSH Hash",
  :description => "hash of ssh attributes",
  :type => "hash"

attribute "auth_ssh/keyfile",
  :display_name => "SSH Private Key",
  :description => "The private SSH key of another instance that gets installed on this instance.  It allows this instance to SSH into another instance to update the configuration files. Select input type 'key' from the dropdown and then select an SSH key that is installed on the other instance.",
  :required => true  
  
attribute "auth_ssh/dir",
  :display_name => "SSH Directory",
  :description => "location of user's ssh directory",
  :default => "/root/.ssh"

attribute "auth_ssh/config_dir",
  :display_name => "SSH config.d Directory",
  :description => "The location where each host's config.d file should be stored. (NOTE: all entries in .ssh/config must have a config.d file)",
  :default => "/root/.ssh/config.d"
  

