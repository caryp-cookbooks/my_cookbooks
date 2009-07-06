maintainer        "RightScale, Inc."
maintainer_email  "cookbooks@rightscale.com"
license           "Copyright (c) 2009 RightScale, Inc, All Rights Reserved Worldwide."
description       "installs the git fast version control system"
version           "0.1"

recipe            "repo_git::pull", "get source code from repository"

attribute "repo_git",
  :display_name => "git hash",
  :description => "hash of git attributes",
  :type => "hash"
  
attribute "repo_git/url",
  :display_name => "repository url",
  :description => "location of git repository",
  :required => true

attribute "repo_git/dest",
  :display_name => "destination directory",
  :description => "where should we place the local repository?",
  :required => true
  
attribute "repo_git/cred",
  :display_name => "ssh key",
  :description => "private ssh key to use for private repositories",
  :default => ""
  
attribute "repo_git/branch",
  :display_name => "working branch",
  :description => "which branch should be fetched?",
  :default => "master"

