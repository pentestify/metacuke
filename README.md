## Metacuke

### About

The Metacuke project brings together the awesome Metasploit Framework and the excellent Cucumber regression testing framework. It makes it possible to write plain-english tests for your infrastructure which are backed by Metasploit. For example, you can write a test: 

  Scenario:   Check default logins
    Given I have a list of default systems
    And I have a list of default usernames and passwords
    And I check for valid logins via http
    Then I should have 0 valid logins

### Getting Started

Metacuke can be installed by pulling down the repository from Github (https://github.com/jcran/metacuke)

Metacuke must be pointed at an instance of the Metasploit Framework RPC service. You can edit the configuration in the config/metacuke.config file. A sample has been provided in the config/ directory. 

Once the config file has been edited, you must write tests for your infrastructure. You can find samples in the features/ directory.  

### Advanced

For more information on Metasploit, see: http://www.metasploit.com/

For more information on Cucumber, see: http://cukes.info/ 
