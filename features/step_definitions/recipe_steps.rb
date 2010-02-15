When /^I run a recipe named "([^\"]*)" on server "([^\"]*)"\.$/ do |recipe, server_index|
  human_index = server_index.to_i - 1
  STDOUT.puts "#{recipe} -> root@#{@servers[human_index].dns_name}"
  @response = @servers[human_index].run_recipe(recipe)
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

When /^I clear the log on server "(.*)".$/ do |server_index|
  human_index = server_index.to_i - 1
  cmd = "rm -f /var/log/messages; touch /var/log/messages ; chown root:root /var/log/messages ; chmod 600 /var/log/messages"
  @response = @servers[human_index].spot_check(cmd) do |result|
    puts result
  end
  
end

Then /^I should see "(.*)" in the log on server "(.*)"\.$/ do |message, server_index|
  human_index = server_index.to_i - 1
  @servers[human_index].spot_check("grep '#{message}' /var/log/messages") do |result|
    result.should_not == nil
  end
end

Then /^the audit entry should NOT contain "([^\"]*)"\.$/ do |st_match|
  @response[:output].should_not include(st_match)
end
