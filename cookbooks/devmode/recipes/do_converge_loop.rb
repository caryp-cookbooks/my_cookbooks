RETURN_RECIPE = "devmode::do_converge_loop_step"

include_recipe node[:devmode][:converge_loop][:recipe_name]

devmode_converge_loop RETURN_RECIPE do
  remote_recipe RETURN_RECIPE
end