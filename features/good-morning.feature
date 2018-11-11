Feature: Good morning
  As a PA user
  I want PA to greet me in the morning
  So that it looks more human

  Background: Brain connected to translator
    Given the translation from pa to human:
        | intent       | text     |
        | good morning | Morning! |
      And the application is started
      And current user is user

  Scenario: Active channel
     When I send the following line:
       """
       {"event": "presence",
        "from": {"user": "user", "channel": "channel"},
        "to": {"user": "niege", "channel": "brain"}}
       """
      And I send the following line:
        """
        {"event": "new-day",
         "from": {"user": "user", "channel": "incoming"},
         "to": {"user": "niege", "channel": "brain"}}
        """
      Then I receive the following line:
        """
        {"message": "Morning!",
         "from": {"user": "niege", "channel": "brain"},
         "to": {"user": "user", "channel": "channel"}}
        """

  Scenario: Inactive channel
     When I send the following line:
        """
        {"event": "new-day",
         "from": {"user": "user", "channel": "incoming"},
         "to": {"user": "niege", "channel": "brain"}}
        """
     Then I don't get any reply
     When I send the following line:
       """
       {"event": "presence",
        "from": {"user": "user", "channel": "channel"},
        "to": {"user": "niege", "channel": "brain"}}
       """
      Then I receive the following line:
        """
        {"message": "Morning!",
         "from": {"user": "niege", "channel": "brain"},
         "to": {"user": "user", "channel": "channel"}}
        """
