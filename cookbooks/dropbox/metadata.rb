maintainer       "RightScale, Inc."
maintainer_email "cary@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures dropbox"
version          "0.1"

attribute "dropbox",
  :display_name => "Dropbox Application Settings",
  :type => "hash"
  
#
# required attributes
#
attribute "dropbox/user",
  :display_name => "Dropbox User",
  :description => "User name for your dropbox account.",
  :required => true

attribute "dropbox/password",
  :display_name => "Dropbox Password",
  :description => "Passwod for your dropbox user account.",
  :required => true
