@mysql_5.1
Feature: mysql 5.1 v2 (beta) promote operations test
  Tests the RightScale premium ServerTemplate Mysql 5.1 v2 (beta)

  Scenario: Setup 2 server deployment and run basic cluster failover operations
#
# PHASE 1) Bootstrap a backup lineage from scratch
#
    Given A deployment. 
    Then I should stop the servers.
    And A set of RightScripts for MySQL promote operations. 
    Then I should set an oldschool variation lineage.
    Then all servers should go operational.
    Then I should run a command "/etc/init.d/mysql stop" on server "1".
    Then I should run a command "/etc/init.d/mysqld stop" on server "1".
    Then I should run a command "mv /mnt/mysql /mnt/mysql-backup" on server "1".
    Then I should create an EBS stripe on server "1".
    Then the rightscript should complete successfully.
    Then I should run a command "mv /mnt/mysql-backup/* /mnt/mysql" on server "1".
    Then I should run a command "chown -R mysql:mysql /mnt/mysql" on server "1".
    Then I should run a command "/etc/init.d/mysql start" on server "1".
    Then I should run a command "/etc/init.d/mysqld start" on server "1".
    Then I should run a mysql query "create database mynewtest" on server "1".
    Then I should setup admin and replication privileges on server "1".
    Then I should setup master dns to point at server "1".
    When I run a rightscript named "backup" on server "1".
    Then the rightscript should complete successfully.

# This sleep is required for the EBS volume snapshot to settle. 
# The sleep time can vary so if slave init fails with no snapshot, this is a likely culprit.
    Then I should sleep 200 seconds.

    When I run a rightscript named "slave_init" on server "2".
    Then the rightscript should complete successfully.
    When I run a rightscript named "promote" on server "2".
    Then the rightscript should complete successfully.

#
# PHASE 2) Relaunch and run restore operations
#
    Then I should stop the servers.
    Then all servers should go operational.
    And A set of RightScripts for MySQL promote operations. 
    When I run a rightscript named "restore" on server "1".
    Then the rightscript should complete successfully.

    Then I should sleep 200 seconds.
    When I run a rightscript named "slave_init" on server "2".
    Then the rightscript should complete successfully.
    When I run a rightscript named "promote" on server "2".
    Then the rightscript should complete successfully.
