maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          IO.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'LICENSE')))
description      "Installs the git fast version control system"
version          "0.0.1"

recipe  "repo_git::do_pull", "Pulls from a Git repository."
recipe  "repo_git::install_prerequisites", "Install Git."

# grouping "repo/Git",
#   :display_name => "Git Version Control",
#   :description => "Setting for managing a Git source repository"

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
  :display_name => "Depth (Git only)",
  :description => "",
  :default => nil,
  :required => false

attribute "git/enable_submodules",
  :display_name => "Enable Submodules  (Git only)",
  :description => "",
  :default => "false",
  :required => false

attribute "/git/remote",
  :display_name => "Remote  (Git only)",
  :description => "",
  :default => "origin",
  :required => false
  
attribute "git/ssh_key",
  :display_name => "SSH Key  (Git only)",
  :description => "",
  :default => nil,
  :required => false
  