Feature: Access using STDIO
  As a PA sysadmin
  I want PA brain to work through STDIO
  So that I could deploy the PA easily

  Scenario: Running
    When I start the application
     And I send the following line:
       """
       {"text": "ping", "from": {"user": "user", "channel": "channel"}, "to": {"user": "niege", "channel": "brain"}}
       """
    Then I receive the following line:
       """
       {"text": "pong", "from": {"user": "niege", "channel": "brain"}, "to": {"user": "user", "channel": "channel"}}
      """
       
