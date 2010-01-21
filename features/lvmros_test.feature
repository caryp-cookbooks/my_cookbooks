Feature: lvmros_test Features
  Tests the RightScale premium lvmros provider

  Scenario: All lvmros feature tests should pass
    Given A deployment named "Cary's Sandbox"
    And A server named "right_resources dev - caryp"
    Then I should successfully run a recipe named "lvmros_test::test_s3" 

        