Feature: Reconnect to translator
  As a system administrator
  I want PA brain to reconnect to translator service when it loses connection
  So that the system is more robust

  Scenario: No service on start
    Given the application is started with alternative translator address
      And current user is user
     When I send the following line:
       """
       {"message": "Привет",
        "from": {"user": "user", "channel": "channel"},
        "to": {"user": "niege", "channel": "brain"}}
       """
      And alternative translator becomes active
     Then the application connects to alternative translator
      And alternative translator receives the following request:
       """
       {"text": "Привет"}
       """

  Scenario: Service restarts
    Given alternative translator is running
      And the application is started with alternative translator address
     When alternative translator goes offline
      And alternative translator becomes active
     Then the application connects to alternative translator

  Scenario: Wait until restart
    Given alternative translator is running
      And the application is started with alternative translator address
      And current user is user
     When alternative translator goes offline
      And I send the following line:
       """
       {"message": "Привет",
        "from": {"user": "user", "channel": "channel"},
        "to": {"user": "niege", "channel": "brain"}}
       """
      And alternative translator becomes active
     Then the application connects to alternative translator
      And alternative translator receives the following request:
       """
       {"text": "Привет"}
       """
