@php_test

Feature: PHP Server Test
  Tests the PHP servers

Scenario: PHP server test

  Given an operational app deployment

  Then the app tests should succeed
  #And the lb tests should succeed
    #Given A deployment with frontends
    When I cross connect the frontends
    Then the cross connect script completes successfully
    And I should see all servers in the haproxy config
    And I should see all servers being served from haproxy

  And the php tests should secceed

  When I reboot the app deployment

  Then the app tests should succeed
  And the lb tests should succeed
  And the php tests should secceed

