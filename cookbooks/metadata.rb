maintainer        "RightScale, Inc."
maintainer_email  "cookbooks@rightscale.com"
license           "Copyright (c) 2009 RightScale, Inc, All Rights Reserved Worldwide."
description       "installs the apache2 webserver"
version           "0.1"

recipe            "repo_git::pull", "get source code from repository"

attribute "web_apache",
  :display_name => "apache hash",
  :description => "hash of attributes",
  :type => "hash"
  
attribute "web_apache/contact",
  :display_name => "contact email ",
  :description => "contact email address for web admin",
  :default => "root@localhost"

attribute "web_apache/mpm",
  :display_name => "Multi-Processing Module",
  :description => "setting for MPM, ",
  :multiple_values => true,
  :default => [ "worker", "prefork" ]

