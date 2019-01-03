Feature: Connect to router
  As a PA system administrator
  I want brain to connect to the router using TCP sockets
  So that I could orchestrate the whole setup using docker compose

  @tcp_router
  Scenario: Connect to router
    Given the router is started
      And the application is started
     Then the application connects to the router
     When the user is switched to user
      And I send the following line:
       """
       {"message": "hello",
        "from": {"user": "user", "channel": "channel"},
        "to": {"user": "niege", "channel": "brain"}}
       """
     Then translator receives the following request:
       """
       {"text": "hello"}
       """

  @tcp_router
  Scenario: Wait for router to start
    Given the application is started
      And the router is started
     Then the application connects to the router
     When the user is switched to user
      And I send the following line:
       """
       {"message": "hello",
        "from": {"user": "user", "channel": "channel"},
        "to": {"user": "niege", "channel": "brain"}}
       """
     Then translator receives the following request:
       """
       {"text": "hello"}
       """

  @tcp_router
  Scenario: Reconnect to router
    Given the router is started
      And the application is started
     Then the application connects to the router
     When router restarts
     Then the application connects to the router
     When the user is switched to user
      And I send the following line:
       """
       {"message": "hello",
        "from": {"user": "user", "channel": "channel"},
        "to": {"user": "niege", "channel": "brain"}}
       """
     Then translator receives the following request:
       """
       {"text": "hello"}
       """
