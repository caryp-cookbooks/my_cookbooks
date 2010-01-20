Feature: state_test Features
  In order to make sure core saves node state correctly

  Scenario: If I save a node attribute in one converge, it should persist in a second converge
    Given A deployment named "Cary's Sandbox"
    And A server named "right_resources dev - caryp"
    Then I should successfully run a recipe named "state_test::check_value" 

        