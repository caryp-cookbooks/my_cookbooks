@providers
Feature: LVM Provider re-converge test
  
  Make sure lvm provider is idempotent 

  Scenario: The LVM Stress Test template should go operational
    Given A deployment.
    Then all servers should go operational.
    
  Scenario: The LVM test should loop multiple times
    Given A deployment.
    Then all servers should go operational.
    Then all servers should successfully run a recipe named "devmode::do_converge_loop".
      
 
  