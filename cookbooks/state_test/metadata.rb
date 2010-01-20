maintainer       "RightScale, Inc."
maintainer_email "cary@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures state_test"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

recipe "state_test::default", "Run this as a boot script."
recipe "state_test::check_value", "Run this as a operational script."

attribute "state_test/value",
  :display_name => "Value that should be overwrite test recipe value",
  :recipes => [ "state_test::default" ]