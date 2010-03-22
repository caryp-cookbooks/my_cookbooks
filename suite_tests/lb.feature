@lb_test

Feature: LB Server Test
  Tests the LB servers

Scenario: LB server test

  Given A deployment

  When I launch the frontends
  Then the frontends become operational

  When I launch the appservers
  Then the appservers become operational

#  When I cross connect the frontends
#  Then the cross connect script completes successfully
#  And I should see all servers in the haproxy config
#  And I should see all servers being served from haproxy 

  Given with a known OS
#  When I restart haproxy on the frontends
#  Then haproxy status should be good

#  When I restart apahce on all servers
#  Then apache status should be good

  When I force log rotation
  Then I should see "/mnt/log/httpd/haproxy.log.1"
  And I should see "/mnt/log/httpd/access_log.1"
