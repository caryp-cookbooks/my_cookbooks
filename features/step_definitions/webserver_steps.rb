Given /^An "([^\"]*)" for an operational app server$/ do |arg1|
  puts "entering op server with value #{arg1}"
  @endpoint = arg1
end

Given /^A server running on "([^\"]*)"$/ do |arg1|
  @port = arg1
end

#
# Make webserver request 
#
When /^I query "([^\"]*)"$/ do |uri|
  uri = uri + '/' unless uri.nil? 
  #puts "about to do: curl -s #{@endpoint}#{url}"
  @response = `curl -s #{@endpoint}#{uri}` 
end

When /^I query "([^\"]*)" on all servers$/ do |uri|
  uri = uri + '/' unless uri.nil?
  @all_servers.each_with_index do |s,i|
    @all_responses[i] = `curl -s #{s['dns-name']}:#{@port}#{uri}`
  end
end

# 
# Grep within response
#
Then /^I should see "([^\"]*)" in the response$/ do |message|
  #puts "looking for #{message} in #{@response}"
  @response.should include(message)
end

Then /^I should see "([^\"]*)" in all the responses$/ do |message|
  @all_servers.each_with_index do |s,i|
    @all_responses[i].should include(message) 
  end
end 

Then /^I should not see "([^\"]*)" in the response$/ do |message|
  @response.should_not include(message) 
end

Then /^I should not see "([^\"]*)" in all the responses$/ do |message|
  @all_servers.each_with_index { |s,i| @all_responses[i].should_not include(message) }
end

