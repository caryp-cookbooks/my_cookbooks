When /^I run a recipe named "([^\"]*)" on server "([^\"]*)"\.$/ do |recipe, server_index|
  human_index = server_index.to_i - 1
  STDOUT.puts "#{recipe} -> root@#{@servers[human_index].dns_name}"
  @response = @servers[human_index].run_recipe(recipe) unless @ssh_key_path
  @response = @servers[human_index].run_recipe(recipe, @ssh_key_path) if @ssh_key_path # hackey hack hack
end 

Then /I should successfully run a recipe named "(.*)"/ do |recipe|
  @server.run_recipe(recipe)
end 

Then /^I should run a recipe named "([^\"]*)" on server "([^\"]*)"\.$/ do |recipe, server_index|
  human_index = server_index.to_i - 1
  @servers[human_index].run_recipe(recipe)
end 

Then /^it should converge successfully\.$/ do
  @response[:status].should == true
end

Then /^I should see "(.*)" in the log on server "(.*)"\.$/ do |message, server_index|
  human_index = server_index.to_i - 1
  @servers[human_index].spot_check("grep '#{message}' /var/log/messages") do |result|
    result.should_not == nil
  end
end