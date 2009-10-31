maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures repo_svn"
long_description  "Installs the Subversion version control system"
version          "0.1"

recipe  "repo_svn::do_pull", "Pulls from a Subversion repository."
recipe  "repo_svn::install_prerequisites", "Install Subversion."

# grouping "repo/svn",
#   :display_name => "Subversion"

attribute "svn/repository",
  :display_name => "Repository Url",
  :description => "",
  :required => true
  
attribute "svn/destination",
  :display_name => "Repository Destination",
  :description => "Where should I put the files?",
  :default => "/tmp",
  :required => true,
  :recipes => [ "repo_svn::do_pull" ]
  
attribute "svn/revision",
  :display_name => "Revision/Branch/Tag",
  :description => "",
  :required => false

attribute "svn/username",
  :display_name => "User Name",
  :description => "",
  :required => false
  
attribute "svn/password",
  :display_name => "Password",
  :description => "",
  :required => false

attribute "svn/arguments",
  :display_name => "Arguments",
  :description => "",
  :required => false
  
  