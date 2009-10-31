maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          IO.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'LICENSE')))
description      "Manages the Git fast version control system"
version          "0.0.1"

provides "provider:repo" # not really in metadata spec yet. Format TBD.

recipe  "repo_git::default", "Runs recipe 'repo_git::install_prerequisites'"
recipe  "repo_git::install_prerequisites", "Installs Git."
recipe  "repo_git::do_pull", "Pulls from a Git repository."

# grouping "repo/git",
#   :display_name => "Git Version Control",
#   :description => "Settings for managing a Git source repository"

attribute "git/repository",
  :display_name => "Repository Url",
  :description => "",
  :required => true
  
attribute "git/destination",
  :display_name => "Repository Destination",
  :description => "Where should I put the files?",
  :default => "/tmp",
  :required => true,
  :recipes => [ "repo_git::do_pull" ]
  
attribute "git/branch",
  :display_name => "Branch/Tag",
  :description => "",
  :required => false

attribute "git/depth",
  :display_name => "Depth",
  :description => "",
  :default => nil,
  :required => false

attribute "git/enable_submodules",
  :display_name => "Enable Submodules",
  :description => "",
  :default => "false",
  :required => false

attribute "/git/remote",
  :display_name => "Remote",
  :description => "",
  :default => "origin",
  :required => false
  
attribute "git/ssh_key",
  :display_name => "SSH Key",
  :description => "",
  :default => nil,
  :required => false
  