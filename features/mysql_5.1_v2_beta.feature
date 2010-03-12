Feature: mysql 5.1 v2 (beta) promote operations test
  Tests the RightScale premium ServerTemplate Mysql 5.1 v2 (beta)

  Scenario: Setup 2 server deployment and run basic cluster failover operations
    Given A deployment. 
    Then all servers should go operational.
    Then I should run a mysql query "drop database mynewtest" on server "1".
    Then I should run a mysql query "drop database mynewtest" on server "2".
    And A set of RightScripts for MySQL promote operations. 
    When I run a rightscript named "restore" on server "1".
    Then the rightscript should complete successfully.

    When I run a rightscript named "init_slave" on server "2".
    Then the rightscript should complete successfully.
    When I run a rightscript named "promote" on server "2".
    Then the rightscript should complete successfully.
