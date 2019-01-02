Feature: Using translator
  As an author of PA's natural language code
  I want PA brain to work with translator
  So that I could separate natural language code from brain itself

  Background: Brain connected to translator
    Given the translation from human to pa:
        | text   | intent |
        | Привет | hello  |
      And the translation from pa to human:
        | intent | text     |
        | hello  | Приветик |
    Given the application is started
      And current user is user

  Scenario: Send human text to translator
     When I send the following line:
       """
       {"message": "Привет",
        "from": {"user": "user", "channel": "channel"},
        "to": {"user": "niege", "channel": "brain"}}
       """
     Then translator receives the following request:
       """
       {"text": "Привет"}
       """

  Scenario: Send intent for translation
     When I send the following line:
       """
       {"message": "Привет",
        "from": {"user": "user", "channel": "channel"},
        "to": {"user": "niege", "channel": "brain"}}
       """
     Then translator receives the following request:
       """
       {"text": "Привет"}
       """
      And translator receives the following request:
       """
       {"intent": "hello"}
       """
     Then I receive the following line:
        """
        {"message": "Приветик",
         "from": {"user": "niege", "channel": "brain"},
         "to": {"user": "user", "channel": "channel"}}
        """

  @tcp_translator
  Scenario: Using TCP socket
     When I send the following line:
       """
       {"message": "Привет",
        "from": {"user": "user", "channel": "channel"},
        "to": {"user": "niege", "channel": "brain"}}
       """
     Then translator receives the following request:
       """
       {"text": "Привет"}
       """
