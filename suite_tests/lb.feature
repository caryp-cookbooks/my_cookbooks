@lb_test

Feature: LB Server Test
  Tests the LB servers

Scenario: LB server test

  Given A deployment

  When I launch the frontends
  Then the frontends become operational

  When I launch the appservers
  Then the appservers become operational

  When I cross connect the frontends
  Then the cross connect script completes successfully
  And I should see all servers in the haproxy config
  And I should see all servers being served from haproxy 
