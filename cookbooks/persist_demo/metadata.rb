maintainer       "RightScale, Inc."
maintainer_email "cary@rightscale.com"
license          "All rights reserved"
description      "Demonstrates the use of the persist resource parameter."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

recipe "persist_demo::default", "Installs Apache2 and persists the service[apache] resource to the node using the 'persist' flag."
recipe "persist_demo::restart", "Restarts httpd using the persisted service[apache] resource."
