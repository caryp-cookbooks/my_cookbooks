# Run a recipe <count> times.

node[:devmode][:recipe_loop][:count].times do |count|
  log "============== Running #{node[:devmode][:recipe_loop][:recipe_name]} (#{count}/#{node[:devmode][:recipe_loop][:count]}) ============="
  include_recipe node[:devmode][:recipe_loop][:recipe_name]
end