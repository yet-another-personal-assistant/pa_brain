Feature: Active user
  As a PA user
  I want the brain to only respond to my messages
  So that it doesn't accidentally leak my private information to other users

  Background: Brain connected to translator
    Given the translation from human to pa:
        | text | intent         |
        | x    | unintelligible |
      And the translation from pa to human:
        | intent          | text            |
        | dont-understand | dont-understand |
      And the application is started

  Scenario: No active user
     When I send the following line:
       """
       {"message": "x",
        "from": {"user": "user1", "channel": "channel"},
        "to": {"user": "niege", "channel": "brain"}}
       """
     Then I don't get any reply

  Scenario: Active user
     When I send the following line:
       """
       {"command": "switch-user", "user": "user1"}
       """
     When I send the following line:
       """
       {"message": "x",
        "from": {"user": "user1", "channel": "channel"},
        "to": {"user": "niege", "channel": "brain"}}
       """
    Then I receive the following line:
       """
       {"message": "dont-understand",
        "from": {"user": "niege", "channel": "brain"},
        "to": {"user": "user1", "channel": "channel"}}
      """

  Scenario: Inactive user
     When I send the following line:
       """
       {"command": "switch-user", "user": "user1"}
       """
     When I send the following line:
       """
       {"message": "x",
        "from": {"user": "user2", "channel": "channel"},
        "to": {"user": "niege", "channel": "brain"}}
       """
     Then I don't get any reply
