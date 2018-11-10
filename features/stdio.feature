Feature: Access using STDIO
  As a PA sysadmin
  I want PA brain to work through STDIO
  So that I could deploy the PA easily

  Background: Hello translation
    Given the translation from human to pa:
        | text   | intent |
        | Привет | hello  |
      And the translation from pa to human:
        | intent | text          |
        | hello  | Ой, приветик! |

  Scenario: Running
    When I start the application
     And I send the following line:
       """
       {"command": "switch-user", "user": "user"}
       """
     And I send the following line:
       """
       {"event": "presence",
        "from": {"user": "user", "channel": "channel"},
        "to": {"user": "niege", "channel": "brain"}}
       """
     And I send the following line:
       """
       {"message": "Привет",
        "from": {"user": "user", "channel": "channel"},
        "to": {"user": "niege", "channel": "brain"}}
       """
    Then I receive the following line:
       """
       {"message": "Ой, приветик!",
        "from": {"user": "niege", "channel": "brain"},
        "to": {"user": "user", "channel": "channel"}}
      """
