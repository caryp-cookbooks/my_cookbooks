Given /A set of RightScripts for MySQL promote operations\.$/ do
  st = ServerTemplate.find(@servers[1].server_template_href)
  @scripts_to_run = {}
  @scripts_to_run['restore'] = st.executables.detect { |ex| ex.name =~  /restore and become/i }
  @scripts_to_run['slave_init'] = st.executables.detect { |ex| ex.name =~ /slave init v2/ }
  @scripts_to_run['promote'] = st.executables.detect { |ex| ex.name =~ /promote to master/ }
  @scripts_to_run['backup'] = st.executables.detect { |ex| ex.name =~ /EBS backup/ }
# hardwired script! hax! (this is an 'anyscript' that users typically use to setup the master dns)
  @scripts_to_run['master_init'] = RightScript.new('href' => "/right_scripts/195053")
  @scripts_to_run['create_stripe'] = RightScript.new('href' => "/right_scripts/171443")
end

Then /^I should run a mysql query "([^\"]*)" on server "([^\"]*)"\.$/ do |query, server_index|
  human_index = server_index.to_i - 1
  query_command = "echo -e \"#{query}\"| mysql"
  @servers[human_index].spot_check(query_command) { |result| puts result }
end

Then /^I should setup admin and replication privileges on server "([^\"]*)"\.$/ do |server_index|
  human_index = server_index.to_i - 1
  admin_grant = "grant all privileges on *.* to admin_user@\'%\' identified by \'admin_passwd\'"
  rep_grant = "grant replication slave on *.* to replication_user@\'%\' identified by \'replication_passwd\'"
  admin_grant2 = "grant all privileges on *.* to admin_user@\'localhost\' identified by \'admin_passwd\'"
  rep_grant2 = "grant replication slave on *.* to replication_user@\'localhost\' identified by \'replication_passwd\'"
  [admin_grant, rep_grant, admin_grant2, rep_grant2].each do |query|
    query_command = "echo -e \"#{query}\"| mysql"
    puts @servers[human_index].spot_check_command(query_command)
  end
end

Then /^I should create an EBS stripe on server "([^\"]*)"\.$/ do |server_index|
  require 'pp'
  human_index = server_index.to_i - 1
# this needs to match the deployments inputs for lineage and stripe count.
  options = { "EBS_MOUNT_POINT" => "text:/mnt/mysql", 
              "EBS_STRIPE_COUNT" => "text:1", 
              "EBS_VOLUME_SIZE_GB" => "text:1", 
              "EBS_LINEAGE" => @lineage }
  puts "Create stripe called with these options:"
  pp options            
  @status = @servers[human_index].run_script(@scripts_to_run['create_stripe'], options)
  @audit_link = @servers[human_index].audit_link
end
  
Then /^I should setup master dns to point at server "([^\"]*)"\.$/ do |server_index|
  human_index = server_index.to_i - 1
  @servers[human_index].run_script(@scripts_to_run['master_init'], {'DB_TEST_MASTER_DNSID' => 'text:4635073'})
end
