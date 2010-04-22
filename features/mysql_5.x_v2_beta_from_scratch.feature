@mysql_5.x
Feature: mysql 5.x v2 (beta) promote operations test image
  Tests the RightScale premium ServerTemplate Mysql v2 (beta)

  Scenario: Setup 2 server deployment and run basic cluster failover operations
#
# PHASE 1) Bootstrap a backup lineage from scratch
#
    Given A deployment. 
    And A set of RightScripts for MySQL promote operations. 
    Then I should stop the mysql servers.
    Then I should set an oldschool variation lineage.
    Then I should set a variation stripe count of "1".
    Then I should set a variation MySQL DNS.
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
# This sleep is to wait for DNS to settle
    Then I should sleep 50 seconds.
    When I run a rightscript named "backup" on server "1".
    Then the rightscript should complete successfully.

# This sleep is required for the EBS volume snapshot to settle. 
# The sleep time can vary so if slave init fails with no snapshot, this is a likely culprit.
    Then I should sleep 600 seconds.
# Might as well perform this check here, after waiting a while for servers anyways.
    Then the servers should have monitoring enabled.

    When I run a rightscript named "slave_init" on server "2".
    Then the rightscript should complete successfully.
    When I run a rightscript named "promote" on server "2".
    Then the rightscript should complete successfully.

#
# PHASE 2) Relaunch and run restore operations
#
    Then I should stop the mysql servers.
    Then all servers should go operational.
    And A set of RightScripts for MySQL promote operations. 
    When I run a rightscript named "restore" on server "1".
    Then the rightscript should complete successfully.

    Then I should sleep 600 seconds.
    When I run a rightscript named "slave_init" on server "2".
    Then the rightscript should complete successfully.
    When I run a rightscript named "promote" on server "2".
    Then the rightscript should complete successfully.

#
# PHASE 3)
#

    Then I should reboot the servers.
# This sleep is so that we don't immediately get an operational state.
    Then I should sleep 60 seconds.
    Then I should wait for the servers to be operational with dns.

#
# PHASE 4) cleanup
# 
    Then I should release the dns records for use with other deployments.

#TODO: spot check for operational mysql
