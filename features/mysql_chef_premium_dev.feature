Feature: mysql_db premium resources and master/slave cluster operations with ROLLBACK
  Tests the RightScale premium ServerTemplate Mysql Chef (alpha) and configures ROLLBACK

  Scenario: Setup Development ROLLBACK support and run basic cluster failover operations
    Given A deployment. 
    And "2" operational servers.

# DEVELOPMENT ROLLBACK SETUP
    When I run a recipe named "database_test::dev_pristine_backup" on server "1".
    Then it should converge successfully.
    When I run a recipe named "database_test::dev_pristine_backup" on server "2".
    Then it should converge successfully.

    When I run a recipe named "db_mysql::do_restore_and_become_master" on server "1". 
    Then it should converge successfully.

    Then I should sleep 10 seconds.

    When I run a recipe named "db_mysql::do_init_slave" on server "2".
    Then it should converge successfully.
    When I run a recipe named "db_mysql::do_backup" on server "2".
    Then it should converge successfully.
    When I run a recipe named "db_mysql::do_disable_backup" on server "2".
    Then it should converge successfully.
    When I run a recipe named "db_mysql::do_enable_backup" on server "2".
    Then it should converge successfully.
    When I run a recipe named "db_mysql::do_promote_to_master" on server "2".
    Then it should converge successfully.
    When I run a recipe named "db_mysql::do_disable_backup" on server "2".
    Then it should converge successfully.
    When I run a recipe named "db_mysql::do_enable_backup" on server "2".
    Then it should converge successfully.
