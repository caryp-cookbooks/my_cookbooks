maintainer       "RightScale, Inc."
maintainer_email "cary@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures devmode"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

attribute "devmode/recipe_loop/count",
  :display_name => "Recipe Loop Count",
  :default => "10",
  :recipes => [ "devmode::do_recipe_loop" ]

attribute "devmode/recipe_loop/recipe_name",
  :display_name => "Recipe Name",
  :description => "The name of the recipe to run in a loop. Syntax: <cookbook>::<recipe>",
  :default => "10",
  :recipes => [ "devmode::do_recipe_loop" ]