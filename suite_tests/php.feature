@php_test

Feature: PHP Server Test
  Tests the PHP servers

Scenario: PHP server test

  Given an operational app deployment
  Given with a known OS

  Then the app tests should succeed
  And the lb tests should succeed

  When I reboot the app deployment

  Then the app tests should succeed
  And the lb tests should succeed
#  And the php tests should succeed
