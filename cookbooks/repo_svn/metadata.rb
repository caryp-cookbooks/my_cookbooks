maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          IO.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'LICENSE')))
description      "Manages the Subversion version control system"
version          "0.0.1"

provides "provider:repo" # not really in metadata spec yet. Format TBD.

recipe  "repo_svn::default", "Runs recipe 'repo_svn::install_prerequisites'"
recipe  "repo_svn::install_prerequisites", "Install Subversion."
recipe  "repo_svn::do_pull", "Pulls from a Subversion repository."

# grouping "repo/svn",
#   :display_name => "Subversion Source Control",
#   :description => "Settings for managing a Subversion source repository"

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
  
  