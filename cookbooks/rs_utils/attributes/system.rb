rs_utils Mash.new unless attribute?("rs_utils")

#
# Optional
#
rs_utils[:timezone] = "UTC"                    unless rs_utils.has_key?(:timezone)
rs_utils[:process_list] = ""                   unless rs_utils.has_key?(:process_list)
rs_utils[:hostname] = "asdf" unless rs_utils.has_key?(:hostname)
#rs_utils[:hostname] = "#{ENV['HOSTNAME']}"     unless rs_utils.has_key?(:hostname)




#
# Do not edit
#
case platform
when "redhat","centos","fedora","suse"
  rs_utils[:logrotate_config] = "/etc/logrotate.d/syslog"
  rs_utils[:collectd_config] = "/etc/collectd.conf"
  rs_utils[:collectd_plugin_dir] = "/etc/collectd.d"
when "debian","ubuntu"
  rs_utils[:logrotate_config] = "/etc/logrotate.d/syslog-ng"
  rs_utils[:collectd_config] = "/etc/collectd/collectd.conf"
  rs_utils[:collectd_plugin_dir] = "/etc/collectd/conf"
end

case kernel[:machine]
when "i686"
  rs_utils[:collectd_lib] = "/usr/lib/collectd"
else 
  rs_utils[:collectd_lib] = "/usr/lib64/collectd"
end