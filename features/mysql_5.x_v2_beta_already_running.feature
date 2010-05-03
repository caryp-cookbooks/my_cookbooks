@mysql_5.x
Feature: mysql 5.x v2 (beta) promote operations test image
  Tests the RightScale premium ServerTemplate Mysql v2 (beta)

  Scenario: Setup 2 server deployment and run basic cluster failover operations

    Given A deployment. 
    And A set of RightScripts for MySQL promote operations. 
    Then all servers should go operational.
    When I run a rightscript named "backup" on server "1".
    Then the rightscript should complete successfully.
    Then I should run a command "gem sources -a http://gems.rubyforge.org" on server "1".
    Then I should run a command "gem update --system" on server "1".
    Then I should run a command "gem install activeresource --version 2.3.5 --no-rdoc --no-ri" on server "1".
    Then I should run a command "gem install rest_connection --no-rdoc --no-ri" on server "1".
    Then I should run a command "chmod +x /opt/rightscale/ebs/spec/fail_server.rb" on server "1".
    Then I should run a command "nohup /opt/rightscale/ebs/spec/fail_server.rb" on server "1".
# sleep For fail_server startup
    Then I should sleep 20 seconds.
    When I run a rightscript named "backup" on server "1".
    Then the rightscript should complete successfully.

