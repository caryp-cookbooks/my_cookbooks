# Run a recipe <count> times.

total = node[:devmode][:recipe_loop][:total].to_i
name = node[:devmode][:recipe_loop][:recipe_name]
count = node[:devmode][:recipe_loop][:count]

log "Skipping #{__FILE__}. Loop count missing." unless total
log "Skipping #{__FILE__}. Recipe name to loop is missing." unless name

if name
  TAG = "devmode:loop=#{name}"
  log "Tag server for loop request. Tag: #{TAG}"
  right_link_tag TAG
end

if name && total 
    # Run the recipe
    log "============== Running #{name} (#{count}/#{total}) ============="
    include_recipe name
    
    # Use remote_recipe "ping-pong" to syncronize runs 
    remote_recipe "ping-pong the running of recipe" do
      only_if do total < count end
      recipe "devmode::do_recipe_loop_step"
      recipients_tags TAG
    end

    # Increment loop count in node
    node[:devmode][:recipe_loop][:count] = "#{count.to_i+1}"
end