maintainer       "RightScale, Inc."
maintainer_email "cary@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures backup_test"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

attribute "test/s3/user",
  :display_name => "Amazon Access Key ID",
  :required => true,
  :recipes => [ "backup_test::test_s3" ]

attribute "test/s3/key",
  :display_name => "Amazon Secret Access Key",
  :required => true,
  :recipes => [ "backup_test::test_s3" ]
  
attribute "test/cloudfiles/user",
  :display_name => "Rackspace Username",
  :required => true,
  :recipes => [ "backup_test::test_cloudfiles" ]

attribute "test/cloudfiles/key",
  :display_name => "Rackspace Authorization Key",
  :required => true,
  :recipes => [ "backup_test::test_cloudfiles" ]