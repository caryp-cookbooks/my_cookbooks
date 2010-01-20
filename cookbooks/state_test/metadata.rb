maintainer       "RightScale, Inc."
maintainer_email "cary@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures state_test"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

attribute "state_test/value",
  :display_name => "Value that should be overwrite test recipe value",
  :recipes => [ "state_test::default" ]