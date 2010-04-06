maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          IO.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'LICENSE')))
description      "Manages the Git fast version control system"
version          "0.0.1"

provides "provider:repo" # not really in metadata spec yet. Format TBD.

recipe  "repo_git::default", "Runs recipe 'repo_git::install_prerequisites'"

# grouping "git/default",
#   :display_name => "Git Client Default Settings",
#   :description => "Settings for managing a Git source repository"

attribute "git/default/repository",
  :display_name => "Repository Url",
  :description => "",
  :required => true
  
attribute "git/default/branch",
  :display_name => "Branch/Tag",
  :description => "",
  :required => false

attribute "git/default/depth",
  :display_name => "Depth",
  :description => "",
  :default => nil,
  :required => false

attribute "git/default/enable_submodules",
  :display_name => "Enable Submodules",
  :description => "",
  :default => "false",
  :required => false

attribute "/git/default/remote",
  :display_name => "Remote",
  :description => "",
  :default => "origin",
  :required => false
  
attribute "git/default/ssh_key",
  :display_name => "SSH Key",
  :description => "",
  :default => nil,
  :required => false
  