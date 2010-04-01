@lb_test

Feature: PHP Server Test
  Tests the PHP servers

Scenario: PHP server test

  Given A deployment

  When I launch the "frontend" servers
  Then the "frontend" servers become operational

  When I launch the "app" servers
  Then I sleep for "30" seconds
  Then the "app" servers become operational

  Given I am testing the "all"
  And I am using port "8000"
#  Then I run the unified app tests on the servers
  Then I should see "html serving succeeded." from "/index.html" on the servers
  Then I should see "configuration=succeeded" from "/appserver/" on the servers
  Then I should see "I am in the db" from "/dbread/" on the servers
  Then I should see "hostname=" from "/serverid/" on the servers

#  Then the lb tests should succeed
  Then I should see all "app" servers in the haproxy config

  Given with a known OS
  When I restart haproxy on the frontend servers
  Then haproxy status should be good

#  When I restart apache on the frontend servers
#  Then apache status should be good on the frontend servers

#  Given I am testing the "frontend"
#  When I force log rotation
#  Then I should see "/mnt/log/httpd/haproxy.log.1"

#  Given I am testing the "all"
#  When I force log rotation
#  Then I should see "/mnt/log/httpd/access_log.1"

  Given I am testing the "frontend"
  When I reboot the servers
  Then I sleep for "120" seconds
  #Then the "frontend" servers become non-operational
  Then the "frontend" servers become operational

  Then I should see "html serving succeeded." from "/index.html" on the servers
  Then I should see "configuration=succeeded" from "/appserver/" on the servers
  Then I should see "I am in the db" from "/dbread/" on the servers

  Given I am testing the "app"
  When I reboot the servers
  Then I sleep for "120" seconds
#  Then the "app" servers become non-operational
  Then the "app" servers become operational
  Then I sleep for "30" seconds

  Then I should see "html serving succeeded." from "/index.html" on the servers
  Then I should see "configuration=succeeded" from "/appserver/" on the servers
  Then I should see "I am in the db" from "/dbread/" on the servers

