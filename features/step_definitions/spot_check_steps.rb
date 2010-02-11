Then /^I should run a command "([^\"]*)" on server "([^\"]*)"\.$/ do |command, server_index|
  human_index = server_index.to_i - 1
  @servers[human_index].spot_check(command) { |result| puts result }
end

Then /^I should run a mysql query "([^\"]*)" on server "([^\"]*)"\.$/ do |query, server_index|
  human_index = server_index.to_i - 1
  query_command = "echo -e '#{query}'|mysql"
  @servers[human_index].spot_check(query_command) { |result| puts result }
end

When /^I run "([^\"]*)"$/ do |command|
  @response = @server.spot_check_command?(command)
end

When /^I run "([^\"]*)" on all servers$/ do |command|
  @all_servers.each_with_index do |s,i|
    @all_responses[i] = s.spot_check_command?(command)
  end
end