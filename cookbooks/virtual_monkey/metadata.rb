maintainer       "RightScale, Inc."
maintainer_email "cary@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures virtual_monkey"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

attribute "db_mysql/bind_address",
  :display_name => "Database Bind Address",
  :default => "0.0.0.0"