@grid

Feature: Grid Server Test
  Tests the Reboot servers

Scenario: Grid server test

  Given A deployment

  When I launch the "JC" servers
  Then the "frontend" servers become operational

  When I launch the "JW" servers
  Then the "frontend" servers become operational

  Given I am testing the "JC"
  When I reboot the servers
  And the "JC" servers become operational

  Given I am testing the "JW"
  When I reboot the servers
  And the "JW" servers become operational

