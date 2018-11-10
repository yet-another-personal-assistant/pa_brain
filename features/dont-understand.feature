Feature: Don't understand
  As a brain developer
  I want brain to clearly state that it doesn't understand the command
  So that I could learn about unexpected/unimplemented commands

  Background: Brain connected to translator
    Given the translation from human to pa:
        | text | intent         |
        | x    | unintelligible |
      And the translation from pa to human:
        | intent          | text            |
        | dont-understand | dont-understand |
      And the application is started
      And current user is user

  Scenario: Unknown command
     When I send the following line:
       """
       {"message": "x",
        "from": {"user": "user", "channel": "channel"},
        "to": {"user": "niege", "channel": "brain"}}
       """
     Then I receive the following line:
        """
        {"message": "dont-understand",
         "from": {"user": "niege", "channel": "brain"},
         "to": {"user": "user", "channel": "channel"}}
        """
       
