Feature: webapp test
  Tests the RightScale app stack

  Scenario: Basic test


    Given A deployment named "Regression Test - tomcat6"
    And "2" operational servers named "Tomcat6 FE set1"
    #And "2" operational servers named "Tomcat6 App set1"

    When I query "/" on all servers 
    Then I should see "Basic html serving succeeded." in all the responses

    When I query "/appserver" on all servers
    Then I should see "configuration=succeeded" in all the responses 

    When I query "/dbread" on all servers
    Then I should see "I am in the db" in all the responses

    When I query "/foo" on all servers
    Then I should see "HTTP Status 404" in all the responses
    
    When I query "/foo" on all servers
    Then I should not see "asdf" in all the responses

    When I run "test -d /mnt/log/tomcat6" 
    Then it should exit succesfully 
