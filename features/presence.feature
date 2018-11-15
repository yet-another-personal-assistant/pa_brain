Feature: Channels
  As a PA developer
  I want PA to keep track of active channels
  So that it can communicate to user

  Background: Brain connected to translator
    Given the application is started
      And current user is user

  Scenario: Presence event
     When I send the following line:
       """
       {"event": "presence",
        "from": {"user": "user", "channel": "channel"},
        "to": {"user": "niege", "channel": "brain"}}
       """
      And I send the following line:
        """
        {"command": "say", "text": "test"}
        """
      Then I receive the following line:
        """
        {"message": "test",
         "from": {"user": "niege", "channel": "brain"},
         "to": {"user": "user", "channel": "channel"}}
        """

  Scenario: Gone event
     When I send the following line:
       """
       {"event": "presence",
        "from": {"user": "user", "channel": "channel"},
        "to": {"user": "niege", "channel": "brain"}}
       """
      And I send the following line:
       """
       {"event": "gone",
        "from": {"user": "user", "channel": "channel"},
        "to": {"user": "niege", "channel": "brain"}}
       """
      And I send the following line:
        """
        {"command": "say", "text": "test"}
        """
     Then I don't get any reply
     When I send the following line:
       """
       {"event": "presence",
        "from": {"user": "user", "channel": "channel2"},
        "to": {"user": "niege", "channel": "brain"}}
       """
     Then I receive the following line:
        """
        {"message": "test",
         "from": {"user": "niege", "channel": "brain"},
         "to": {"user": "user", "channel": "channel2"}}
        """
