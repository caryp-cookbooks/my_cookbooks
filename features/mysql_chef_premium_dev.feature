Feature: mysql_db premium resources and master/slave cluster operations with ROLLBACK
  Tests the RightScale premium ServerTemplate Mysql Chef (alpha) and configures ROLLBACK

  Scenario: Setup Development ROLLBACK support and run basic cluster failover operations
    Given A deployment. 
    Then I should set un-set all tags on all servers in the deployment.
#Then I should set rs_agent_dev:package to "5.2.0".
    And "2" operational servers.

# DEVELOPMENT ROLLBACK SETUP
    When I run a recipe named "database_test::dev_pristine_backup" on server "1".
    Then it should converge successfully.
    When I run a recipe named "database_test::dev_pristine_backup" on server "2".
    Then it should converge successfully.
