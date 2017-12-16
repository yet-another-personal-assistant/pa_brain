# vim: tabstop=4 expandtab shiftwidth=2 softtabstop=2
Feature: Scheduled reminders
  As a personal assistant user
  I want my personal assistant to remind me about stuff
  So that I can do things I'd otherwise forget
  
  Scenario: Reminder
    Given the brain is running
      And already said hello
     When "cron go to bed" event comes
     Then pa says "go to bed"

  Scenario: Japanese reminder
    Given japanese module is enabled
      And the brain is running
      And already said hello
     When "cron study japanese" event comes
     Then pa says "japanese status request"
