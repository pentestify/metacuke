Feature: Check Default Logins
  In order to prevent a default login on a production system
  As an administrator
  I want to check systems for default logins

  Scenario: 	Check default logins
		Given I have a list of production systems
		And I have a list of default usernames
		And I have a list of default passwords
		When I check for valid logins via smb
		Then I should have 0 valid logins
