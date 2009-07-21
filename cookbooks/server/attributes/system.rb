server Mash.new unless attribute?("server")

#
# Optional
#
server[:timezone] = "UTC"      unless server.has_key?(:timezone)
server[:process_list] = ""     unless server.has_key?(:process_list)




#
# Do not edit
#
case platform
when "redhat","centos","fedora","suse"
  server[:logrotate_config] = "/etc/logrotate.d/syslog"
  server[:collectd_config] = "/etc/collectd.conf"
  server[:collectd_plugin_dir] = "/etc/collectd.d"
when "debian","ubuntu"
  server[:logrotate_config] = "/etc/logrotate.d/syslog-ng"
  server[:collectd_config] = "/etc/collectd/collectd.conf"
  server[:collectd_plugin_dir] = "/etc/collectd/conf"
end

case kernel[:machine]
when "i686"
  server[:collectd_lib] = "/usr/lib/collectd"
else 
  server[:collectd_lib] = "/usr/lib64/collectd"
end
