# Run a recipe <count> times.

total = node[:devmode][:recipe_loop][:count].to_i
name = node[:devmode][:recipe_loop][:recipe_name]

log "Skipping #{__FILE__}. Loop count missing." unless total
log "Skipping #{__FILE__}. Recipe name to loop is missing." unless recipe

if name && total
  total.times do |count|
    log "============== Running #{name} (#{count}/#{total}) ============="
    include_recipe name
  end
end