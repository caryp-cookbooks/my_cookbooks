maintainer       "RightScale, Inc."
maintainer_email "cary@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures operational_demo"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

recipe "operational_demo::default", "Installs Apache2 and sets up service resource."
recipe "operational_demo::restart", "Example operational recipe to restart the Apache2 service."
