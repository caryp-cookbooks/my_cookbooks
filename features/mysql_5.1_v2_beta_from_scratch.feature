@mysql_5.1
Feature: mysql 5.1 v2 (beta) promote operations test
  Tests the RightScale premium ServerTemplate Mysql 5.1 v2 (beta)

  Scenario: Setup 2 server deployment and run basic cluster failover operations
    Given A deployment. 
    Then all servers should go operational.
    Then I should set an oldschool variation lineage.
    And A set of RightScripts for MySQL promote operations. 
    Then I should run a mysql query "create database mynewtest" on server "1".
    Then I should setup admin and replication privileges on server "1".
    Then I should setup master dns to point at server "1".
    When I run a rightscript named "backup" on server "1".
    Then the rightscript should complete successfully.
    Then I should sleep 20 seconds.

    When I run a rightscript named "slave_init" on server "2".
    Then the rightscript should complete successfully.
    When I run a rightscript named "promote" on server "2".
    Then the rightscript should complete successfully.
