@php_test

Feature: PHP Server Test
  Tests the PHP servers

Scenario: PHP server test

  Given an operational app deployment
  Given with a known OS

  Then the app tests should succeed
  And the lb tests should succeed

#  And the httpd log dir should exist on all servers
#  And the httpd log symlink should exist

#  When I force log rotation
#  Then I should see the http logs rotated

#  When I reboot the app deployment

#  Then the app tests should succeed
#  And the lb tests should succeed
#  And the php tests should succeed

#    When I run "test -d /mnt/log/tomcat6" on all servers
#    Then it should exit successfully on all servers

#    When I run "test -L /var/log/tomcat6" on all servers
#    Then it should exit successfully on all servers

#    When I run "test -f /etc/logrotate.d/tomcat6" on all servers
#    Then it should exit successfully on all servers
