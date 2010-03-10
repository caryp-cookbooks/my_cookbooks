Then /^I should run a command "([^\"]*)" on server "([^\"]*)"\.$/ do |command, server_index|
  human_index = server_index.to_i - 1
  @servers[human_index].spot_check(command) { |result| puts result }
end

Then /^I should run a mysql query "([^\"]*)" on server "([^\"]*)"\.$/ do |query, server_index|
  human_index = server_index.to_i - 1
  query_command = "echo -e '#{query}'|mysql"
  @servers[human_index].spot_check(query_command) { |result| puts result }
end

Then /^I should setup admin and replication privileges on server "([^\"]*)"\.$/ do |server_index|
  human_index = server_index.to_i - 1
  admin_grant = 'grant all privileges on *.* to admin_user@"%" identified by "admin_passwd"'
  rep_grant = 'grant replication slave on *.* to replication_user@"%" identified by "replication_passwd"'
  query_command = "echo -e '#{admin_grant}'|mysql"
  puts @servers[human_index].spot_check_command(query_command)
  query_command = "echo -e '#{rep_grant}'|mysql"
  puts @servers[human_index].spot_check_command(query_command)
end

Then /^I should create an EBS stripe on server "([^\"]*)"\.$/ do |server_index|
  human_index = server_index.to_i - 1
  @status = @servers[human_index].run_script(@scripts_to_run['create_stripe'], {"EBS_MOUNT_POINT" => "text:/mnt", "EBS_VOLUME_SIZE_GB" => "text:1", "EBS_LINEAGE" => @lineage }) 
  @audit_link = @servers[human_index].audit_link
end
  
Then /^I should setup master dns to point at server "([^\"]*)"\.$/ do |server_index|
  human_index = server_index.to_i - 1
  @servers[human_index].run_script(@scripts_to_run['master_init'], {'DB_TEST_MASTER_DNSID' => 'text:4635073'})
end

When /^I run "([^\"]*)"$/ do |command|
  @response = @server.spot_check_command?(command)
end

When /^I run "([^\"]*)" on all servers$/ do |command|
  @all_servers.each_with_index do |s,i|
    @all_responses[i] = s.spot_check_command?(command)
  end
end


#
# Checking for request sucess/error
#
Then /^it should exit successfully$/ do
  @response.should be true
end

Then /^it should exit successfully on all servers$/ do
  @all_responses.each do |response|
    response.should be true
  end
end

Then /^it should not exit successfully on any server$/ do
  @all_responses.each do |response|
    response.should_not be true
  end
end

