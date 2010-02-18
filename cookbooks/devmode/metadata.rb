maintainer       "RightScale, Inc."
maintainer_email "cary@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures devmode"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

attribute "devmode/recipe_loop/total",
  :display_name => "Recipe Loop Count",
  :default => "10",
  :recipes => [ "devmode::do_recipe_loop", "devmode::do_recipe_loop_step" ]

attribute "devmode/recipe_loop/recipe_name",
  :display_name => "Recipe Name",
  :description => "The name of the recipe to run in a loop. Syntax: <cookbook>::<recipe>",
  :required => true,
  :recipes => [ "devmode::do_recipe_loop", "devmode::do_recipe_loop_step" ]