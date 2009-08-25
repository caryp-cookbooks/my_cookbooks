#
# Chef Solo Config File
#

log_level          :debug
log_location       STDOUT
file_cache_path    "/tmp/chef/cookbooks"
ssl_verify_mode    :verify_none
Chef::Log::Formatter.show_time = false
cookbook_path     ["/var/cache/rightscale/cookbooks/git@github-com-rightscale-cookbooks-git-db_mysql-cookbooks/cookbooks", "/var/cache/rightscale/cookbooks/github-com-opscode-cookbooks-git--"  ]
