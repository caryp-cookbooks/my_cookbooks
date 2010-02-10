Feature: webapp test
  Tests the RightScale app stack

  Scenario: Basic test

# Make sure the DB is up - not testing DB so nothing else
# This will fail unless the DB is a master
#    Given A deployment named "Regression Test - Haproxy Apache"
#    And "1" operational servers named "Unified Master"

#    Given A deployment named "Regression Test - Haproxy Apache"
#    And "2" operational servers named "Apache HAproxy Set1"
#    And "1" operational servers named "TC6 App Set1-1"

    Given A deployment named "Regression Test - Haproxy Apache"
    And "2" operational servers named "Apache HAproxy Set2"

    Given A server running on "80"

    When I query "/" on all servers 
    Then I should see "html serving succeeded." in all the responses

    When I query "/appserver" on all servers
    Then I should see "configuration=succeeded" in all the responses 

    When I query "/dbread" on all servers
    Then I should see "I am in the db" in all the responses

    When I query "/foo" on all servers
    Then I should see "HTTP Status 404" in all the responses
    
    When I query "/foo" on all servers
    Then I should not see "asdf" in all the responses

# Now just the haproxy FE tests
    Given A deployment named "Regression Test - Haproxy Apache"
    And "2" operational servers named "Apache HAproxy Set2"

#    When I run "test -e /home/haproxy/haproxy" on all servers
#    Then it should exit successfully on all servers

    When I run "service haproxy restart" on all servers
    Then it should exit successfully on all servers

    When I run "service haproxy check" on all servers
#    When I run "service haproxy status" on all servers
    Then it should exit successfully on all servers

    When I run "pgrep haproxy" on all servers
    Then it should exit successfully on all servers

    When I run "apachectl -t" on all servers
#    When I run "apache2ctl -t" on all servers
    Then it should exit successfully on all servers

#    When I run "test -d /mnt/log/tomcat6" on all servers
#    Then it should exit successfully on all servers

#    When I run "test -L /var/log/tomcat6" on all servers
#    Then it should exit successfully on all servers

#    When I run "test -d /home/webapps/tomcatapp/current/apptest" on all servers
#    Then it should exit successfully on all servers

#    When I run "test -f /etc/logrotate.d/tomcat6" on all servers
#    Then it should exit successfully on all servers

#    When I run "" on all servers
#    Then it should exit successfully on all servers

