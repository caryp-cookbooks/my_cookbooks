@php

Feature: webapp test
  Tests the RightScale app stack

  Scenario: Basic test

    Given A deployment.
    And A server running on "80"
    And "2" operational servers named "app"
    And with ssh private key

#    When I query "index.html" on all servers 
#    Then I should see "html serving succeeded." in all the responses

    When I query "/appserver/" on all servers
    Then I should see "configuration=succeeded" in all the responses 

    When I query "/dbread/" on all servers
    Then I should see "I am in the db" in all the responses

    When I query "/foo/" on all servers
    Then I should see "Not Found" in all the responses
   
    When I query "/foo/" on all servers
    Then I should not see "asdf" in all the responses

    When I run "test -d /mnt/log/httpd" on all servers
    Then it should exit successfully on all servers

#    When I run "test -L /var/log/tomcat6" on all servers
#    Then it should exit successfully on all servers

#    When I run "test -f /etc/logrotate.d/tomcat6" on all servers
#    Then it should exit successfully on all servers
