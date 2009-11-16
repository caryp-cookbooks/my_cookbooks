maintainer       "RightScale, Inc."
maintainer_email "cary@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures storage_test"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"


attribute "storage_test/s3/user",
  :display_name => "S3 ACCESS_KEY_ID",
  :required => true

attribute "storage_test/s3/key",
  :display_name => "S3 SECRET_ACCESS_KEY",
  :required => true