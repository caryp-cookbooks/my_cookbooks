maintainer       "RightScale, Inc."
maintainer_email "cary@rightscale.com"
license          IO.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'LICENSE')))
description      "Demonstrates the use of the Dependency Injection cookbook design patterns"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

depends "resource:repo" # not really in metadata spec yet. Format TBD.

recipe  "lwrp_demo::do_source_pull", "Pull source from some repository configured at runtime."

attribute "lwrp_demo/destination",
  :display_name => "Destination",
  :description => "Path to download repository contents to.",
  :default => "/tmp/lwrp_demo"