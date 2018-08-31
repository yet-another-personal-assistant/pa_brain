Feature: Using translator
  As an author of PA's natural language code
  I want PA brain to work with translator
  So that I could separate natural language code from brain itself
  
  Background: Brain connected to translator
    Given the application is started
  
  Scenario: Send to translator
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
       
