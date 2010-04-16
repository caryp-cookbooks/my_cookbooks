@lb_test

Feature: LB Server Test
  Tests the LB servers

Scenario: LB server test

  Given A deployment

  When I launch the "frontend" servers
  Then the "frontend" servers become operational

  When I launch the "app" servers
  Then the "app" servers become operational

  Given I am testing the "frontend"
  Given I am using port "80"
  Then I should see "html serving succeeded." from "/index.html" on the servers
  Then I should see "configuration=succeeded" from "/appserver/" on the servers
  Then I should see "I am in the db" from "/dbread/" on the servers
  Then I should see "hostname=" from "/serverid/" on the servers

  Then I should see all "app" servers in the haproxy config

  Given with a known OS
  When I restart haproxy on the frontend servers
  Then haproxy status should be good

  When I restart apache on the frontend servers
  Then apache status should be good on the frontend servers

#  When I force log rotation
#  Then I should see "/mnt/log/httpd/haproxy.log.1"
#  Then I should see "/mnt/log/httpd/access_log.1"

  Given I am testing the "frontend"
  When I reboot the servers
  Then the "frontend" servers become operational

  Then I should see "html serving succeeded." from "/index.html" on the servers
  Then I should see "configuration=succeeded" from "/appserver/" on the servers
  Then I should see "I am in the db" from "/dbread/" on the servers
  Then I should see "hostname=" from "/serverid/" on the servers

