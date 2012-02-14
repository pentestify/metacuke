Feature: Network Audit
  In order to prevent vulnerable system on the production net
  As an administrator
  I want to check for vulnerable systems

  Scenario: Identify unknown systems
    Given I have a list of known systems on the production net
    When I scan for new systems on the production net 
    Then I should have 0 new systems
