maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          IO.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'LICENSE')))
description      "Manages the Subversion version control system"
version          "0.0.1"

provides "provider:repo" # not really in metadata spec yet. Format TBD.

recipe  "repo_svn::default", "Default pattern of loading packages and resources provided"

 grouping "repo/default",
   :display_name => "Subversion Client Default Settings",
   :description => "Settings for managing a Subversion source repository",
   :databag => true   # proposed metadata addition
   
attribute "repo/default/provider",
  :display_name => "Repository Provider Type",
  :description => "",
  :default => "repo_svn"

attribute "repo/default/repository",
  :display_name => "Repository Url",
  :description => "",
  :required => true
  
attribute "repo/default/revision",
  :display_name => "Revision/Branch/Tag",
  :description => "",
  :required => false

attribute "repo/default/username",
  :display_name => "User Name",
  :description => "",
  :required => false
  
attribute "repo/default/password",
  :display_name => "Password",
  :description => "",
  :required => false

attribute "repo/default/arguments",
  :display_name => "Arguments",
  :description => "",
  :required => false
  
