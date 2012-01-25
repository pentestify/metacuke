Feature: Ensure all default services running
  In order to ensure all default services are running
  As an administrator
  I want to check for running services
  And compare to a known good ist

  @test
  Scenario: Check for default services
    Given I scan the default systems
    Then all default services should be up
