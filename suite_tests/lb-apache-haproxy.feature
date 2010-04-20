@lb_test

Feature: LB Server Test
  Tests the LB servers

Scenario: LB server test

  Given A deployment

  When I launch the "FrontEnd" servers
  Then the "FrontEnd" servers become operational

  When I setup deployment input "LB_HOSTNAME" to current "FrontEnd"

  When I launch the "App Server" servers
  Then the "App Server" servers become operational

  Given I am testing the "FrontEnd"
  Given I am using port "80"
  Then I should see "html serving succeeded." from "/index.html" on the servers
  Then I should see "configuration=succeeded" from "/appserver/" on the servers
  Then I should see "I am in the db" from "/dbread/" on the servers
  Then I should see "hostname=" from "/serverid/" on the servers

  Then I should see all "App Server" servers in the haproxy config

  Given with a known OS
  When I restart haproxy on the frontend servers
  Then haproxy status should be good

  When I restart apache on the frontend servers
  Then apache status should be good on the frontend servers

  When I force log rotation
  Then I should see "/mnt/log/httpd/haproxy.log.1"
  Then I should see "/mnt/log/httpd/access_log.1"

  Given I am testing the "FrontEnd"
  When I reboot the servers
  Then the "FrontEnd" servers become operational

  Then I should see "html serving succeeded." from "/index.html" on the servers
  Then I should see "configuration=succeeded" from "/appserver/" on the servers
  Then I should see "I am in the db" from "/dbread/" on the servers
  Then I should see "hostname=" from "/serverid/" on the servers

