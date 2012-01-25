@test	
Feature: Ensure all default services running
  In order to ensure all default services are running
  As an administrator
  I want to check for running services
	And compare to a known good list

	@test
  Scenario: Check for default services
		Given I have a list of default systems and services
		And I scan the default systems
		Then all default services should be up
