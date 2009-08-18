#
# Chef Solo Config File
#

log_level          :debug
log_location       STDOUT
file_cache_path    "/tmp/chef/cookbooks"
ssl_verify_mode    :verify_none
Chef::Log::Formatter.show_time = false
cookbook_path     ["/root/cookbooks/cookbooks", "/root/opscode/cookbooks" ]
