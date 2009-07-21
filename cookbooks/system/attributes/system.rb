system Mash.new unless attribute?("system")

#
# Optional
#
system[:timezone] = "UTC"      unless system.has_key?(:timezone)




#
# Do not edit
#
case platform
when "redhat","centos","fedora","suse"
  system[:logrotate_config] = "/etc/logrotate.d/syslog"
when "debian","ubuntu"
  system[:logrotate_config] = "/etc/logrotate.d/syslog-ng"
end
