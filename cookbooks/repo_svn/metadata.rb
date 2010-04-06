maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          IO.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'LICENSE')))
description      "Manages the Subversion version control system"
version          "0.0.1"

provides "provider:repo" # not really in metadata spec yet. Format TBD.

recipe  "repo_svn::default", "Runs install svn client and setup resources"

# grouping "svn/deafult",
#   :display_name => "Subversion Client Default Settings",
#   :description => "Settings for managing a Subversion source repository"

attribute "svn/default/repository",
  :display_name => "Repository Url",
  :description => "",
  :required => true
  
attribute "svn/default/revision",
  :display_name => "Revision/Branch/Tag",
  :description => "",
  :required => false

attribute "svn/default/username",
  :display_name => "User Name",
  :description => "",
  :required => false
  
attribute "svn/default/password",
  :display_name => "Password",
  :description => "",
  :required => false

attribute "svn/default/arguments",
  :display_name => "Arguments",
  :description => "",
  :required => false
  
  