@rightlink
Feature: Allow instances to tag themselves and run recipes on other remote instances in their deployment.
  
  Tests that the rightlink_tag and remote_recipes work correctly.

  Scenario: Verify remote_recipe and rightlink_tag work using ping-pong cookbook
    Given A deployment named "Regression Test CHEF - unit test - core"
    And "2" operational servers named "5.1.1 - centos"
    When I run a recipe named "ping_pong::do_send_ping" on server "1". 
    Then it should converge successfully.
     
    Then I should sleep 10 seconds.

    Then I should see "do_ping" in the log on server "2".
  
