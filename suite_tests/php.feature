@lb_test

Feature: PHP Server Test
  Tests the PHP servers

Scenario: PHP server test

  Given A deployment
  
  I setup deployment input "MASTER_DB_DNSNAME" to "tester_ip"

  When I launch the "FrontEnd" servers
  Then the "FrontEnd" servers become operational

  When I setup deployment input "LB_HOSTNAME" to current "FrontEnd"

  When I launch the "App Server" servers
  Then the "App Server" servers become operational

  Given I am testing the "all"
  And I am using port "8000"
  Then I should see "html serving succeeded." from "/index.html" on the servers
  Then I should see "configuration=succeeded" from "/appserver/" on the servers
  Then I should see "I am in the db" from "/dbread/" on the servers
  Then I should see "hostname=" from "/serverid/" on the servers

  When I cross connect the frontends
  Then the cross connect script completes successfully
  Then I should see all "all" servers in the haproxy config

  Given with a known OS
  When I restart haproxy on the frontend servers
  Then haproxy status should be good

  When I restart apache on the frontend servers
  Then apache status should be good on the frontend servers

  Given I am testing the "FrontEnd"
  When I force log rotation
  Then I should see rotated apache log "haproxy.log.1" in base dir "/mnt/log" 

  Given I am testing the "all"
  When I force log rotation
  Then I should see rotated apache log "access.log.1" in base dir "/mnt/log" 

  Given I am testing the "FrontEnd"
  When I reboot the servers
  Then the "FrontEnd" servers become operational
  And I am using port "80"
  Then I should see "html serving succeeded." from "/index.html" on the servers
  Then I should see "configuration=succeeded" from "/appserver/" on the servers
  Then I should see "I am in the db" from "/dbread/" on the servers
  And I am using port "8000" 
  Then I should see "html serving succeeded." from "/index.html" on the servers
  Then I should see "configuration=succeeded" from "/appserver/" on the servers
  Then I should see "I am in the db" from "/dbread/" on the servers

  Given I am testing the "App Server"
  When I reboot the servers
  Then the "App Server" servers become operational
  And I am using port "8000"
  Then I should see "html serving succeeded." from "/index.html" on the servers
  Then I should see "configuration=succeeded" from "/appserver/" on the servers
  Then I should see "I am in the db" from "/dbread/" on the servers

# Disconnect test - todo
