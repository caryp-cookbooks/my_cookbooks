maintainer        "RightScale, Inc."
maintainer_email  "cookbooks@rightscale.com"
license           "Copyright (c) 2009 RightScale, Inc, All Rights Reserved Worldwide."
description       "installs the pasenger version of rails"
version           "0.1"

depends "db_mysql"

recipe  "app_rails::setup_db_config", "Configures the rails database.yml file"

attribute "rails",
  :display_name => "Rails Passenger Settings",
  :type => "hash"
  
#
# required attributes
#
attribute "rails/db_app_user",
  :display_name => "database user",
  :description => "username for database access",
  :required => true

attribute "rails/db_app_passwd",
  :display_name => "database password",
  :description => "password for database access",
  :required => true

attribute "rails/db_schema_name",
  :display_name => "database schema name",
  :description => "database schema to use",
  :required => true

attribute "rails/db_dns_name",
  :display_name => "database dns name",
  :description => "FQDN of the database server",
  :required => true

attribute "rails/code",
  :display_name => "Rails Application Code",
  :type => "hash"
  
attribute "rails/code/url",
  :display_name => "repository url",
  :description => "location of application code repository",
  :required => true

attribute "rails/code/user",
  :display_name => "repository username",
  :description => "username for code repository",
  :required => true

attribute "rails/code/credentials",
  :display_name => "repository credentials",
  :description => "credentials for code repository",
  :required => true  

#
# recommended attributes
#
attribute "rails/server_name",
  :display_name => "server name",
  :description => "FQDN for the server",
  :default => "myserver"

attribute "rails/application_name",
  :display_name => "application name",
  :description => "give a name to your application",
  :default => "myapp"

attribute "rails/env",
  :display_name => "rails environment",
  :description => "production, test, staging, etc.",
  :default => "production"
  
attribute "rails/db_mysqldump_file_path",
  :display_name => "mysqldump file path",
  :description => "Full path in git repository to mysqldump file to restore"


#
# optional attributes
#
attribute "rails/version",
  :display_name => "Rails Version",
  :description => "Specify the version of Rails to install",
  :default => "false"

attribute "rails/environment",
  :display_name => "Rails Environment",
  :description => "Specify the environment to use for Rails",
  :default => "production"

attribute "rails/max_pool_size",
  :display_name => "Rails Max Pool Size",
  :description => "Specify the MaxPoolSize in the Apache vhost",
  :default => "4"
  
attribute "rails/code/branch",
  :display_name => "repository branch",
  :description => "branch to pull source from",
  :default => "master"
  
attribute "rails/application_port",
  :display_name => "application port",
  :description => "the port your rails application will listen on",
  :default => "8000"

attribute "rails/spawn_method",
  :display_name => "spawn method",
  :description => "what spawn method should we use?",
  :default => "conservative"

attribute "rails/gems_list",
  :display_name => "gems_list",
  :description => "list of gems required by your application",
  :type => "array",
  :required => false

