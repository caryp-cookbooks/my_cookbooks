@lb_test

Feature: LB Server Test
  Tests the LB servers

Scenario: LB server test

  Given A deployment

  When I launch the "frontend" servers
  Then the "frontend" servers become operational

  When I launch the "app" servers
  Then the "app" servers become operational

  When I query "/index.html" on all "frontend" servers on port "80"
  Then I should see "html serving succeeded." in all the responses
  When I query "/appserver/" on all "frontend" servers on port "80"
  Then I should see "configuration=succeeded" in all the responses
  When I query "/dbread/" on all "frontend" servers on port "80"
  Then I should see "I am in the db" in all the responses
  When I query "/serverid/" on all "frontend" servers on port "80"
  Then I should see "hostname=" in all the responses

  And I should see all "app" servers in the haproxy config

  Given with a known OS
  When I restart haproxy on the frontend servers
  Then haproxy status should be good

  When I restart apache on the frontend servers
  Then apache status should be good on the frontend servers

  When I force log rotation
  Then I should see "/mnt/log/httpd/haproxy.log.1"
  And I should see "/mnt/log/httpd/access_log.1"

  When I reboot the "frontend" servers
  Then the "frontend" servers become non-operational
  And the "frontend" servers become operational

  When I query "/index.html" on all "frontend" servers on port "80"
  Then I should see "html serving succeeded." in all the responses
  When I query "/appserver/" on all "frontend" servers on port "80"
  Then I should see "configuration=succeeded" in all the responses
