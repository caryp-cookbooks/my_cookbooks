maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          IO.read(File.join(File.dirname(__FILE__), 'LICENSE.rdoc'))
description      "Installs common utilities used by RightScale instances"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

#
# optional
#
attribute "rs_utils/timezone",
  :display_name => "Timezone",
  :description => "Sets the server timezone. The Default value is UTC. The server will not be updated for daylight savings time.",
  :default => "UTC"
  
attribute "rs_utils/process_list",
  :display_name => "Process List",
  :description => "Adds extra processes for RightScale to monitor.",
  :default => ""

attribute "rs_utils/private_ssh_key",
  :display_name => "Private SSH Key",
  :description => "Private SSH key to install on instance.",
  :default => ""

