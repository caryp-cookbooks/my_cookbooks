maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          IO.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'LICENSE')))
description      "Manages the Git fast version control system"
version          "0.0.1"

provides "provider:repo" # not really in metadata spec yet. Format TBD.

recipe  "repo_git::default", "Default pattern of loading packages and resources provided"

grouping "git",
 :display_name => "Git Client Default Settings",
 :description => "Settings for managing a Git source repository",
 :databag => true       # proposed metadata addition

attribute "git/repository",
  :display_name => "Repository Url",
  :description => "",
  :required => true
  
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
  