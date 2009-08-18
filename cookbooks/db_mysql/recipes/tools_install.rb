# Copyright (c) 2007-2009 by RightScale Inc., all rights reserved

# Gem requirements
["right_aws", "rest-client", "json", "terminator"].each { |p|  gem_package  p }

directory "/opt/rightscale" do
  recursive true
end

remote_file "/opt/rightscale/dbtools.tgz" do
  source "dbtools-0.18.12.tgz"
end

# unpack dbtool -- happens every time
bash "unpack dbtools" do
  user "root"
  cwd "/opt/rightscale"
  code <<-EOH
    tar xzf dbtools.tgz
    tar -tf dbtools.tgz | xargs chmod ug+x
  EOH
end

#todo: enable this for rightlink
#log "DB RightScale tools are installed and configured."
