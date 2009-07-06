maintainer        "RightScale, Inc."
maintainer_email  "cookbooks@rightscale.com"
license           "Copyright (c) 2009 RightScale, Inc, All Rights Reserved Worldwide."
description       "installs the openssh connectivity tools"
version           "0.1"

recipe            "auth_ssh::add_cred", "add ssh private key and config for use with a given host (if host specified)"

attribute "auth_ssh",
  :display_name => "ssh hash",
  :description => "hash of ssh attributes",
  :type => "hash"

attribute "auth_ssh/keyfile",
  :display_name => "ssh private key",
  :description => "private ssh key to use",
  :required => true  
  
attribute "auth_ssh/dir",
  :display_name => "ssh directory",
  :description => "location of user's ssh directory",
  :default => "/root/.ssh"

attribute "auth_ssh/config_dir",
  :display_name => "ssh config.d directory",
  :description => "where should we place each host's config.d file? (NOTE: all entries in .ssh/config must have a config.d file)",
  :default => "/root/.ssh/config.d"
  

