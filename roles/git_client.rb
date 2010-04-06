name "git_client"
description "The base role pulling code from a git repository"
recipes "repo_git", "lwrp_demo::do_source_pull"
override_attributes "lwrp_demo" => [ "destination" => "/tmp/lwrp_demo" ], 

	"git" =>  [ 
	  "default" => [ 
	    "remote" => "origin", 
	    "branch" => "mephisto",  
	    "enable_submodules" => "false", 
	    "repository" => "git://github.com/rightscale/examples.git"
    ]
  ],
    
  "svn" => [
    "default" => [
  		"repository" => "https://myserver.com/svn/rightscale/cookbooks_test/", 
  		"password" => "mypasswd", 		
  		"username" => "me"
  	]
	]

