
default[:devmode][:loaded_custom_cookbooks] = false
default[:devmode][:recipe_loop][:count] = 1

set_unless[:devmode][:recipe_loop][:total] = 15
default[:devmode][:recipe_loop][:recipe_name] = nil