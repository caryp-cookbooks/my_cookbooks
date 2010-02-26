

When /^I check the haproxy status on all servers$/ do
  @all_servers.each_with_index do |server,i|
    if @all_servers_os[i] == "ubuntu"
      haproxy_check_cmd = "service haproxy status"
    else 
      haproxy_check_cmd = "service haproxy check"
    end
    @all_responses[i] = server.spot_check_command?(haproxy_check_cmd)
  end
end


When /^I check the apache status on all servers$/ do
  @all_servers.each_with_index do |server,i|
    if @all_servers_os[i] == "ubuntu"
      apache_check_cmd = "apache2ctl -t"
    else 
      apache_check_cmd = "apachectl -t"
    end
    @all_responses[i] = server.spot_check_command?(apache_check_cmd)
  end
end

