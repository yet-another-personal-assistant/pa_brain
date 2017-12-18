# vim: tabstop=4 expandtab shiftwidth=2 softtabstop=2
Feature: Scheduled reminders
  As a personal assistant user
  I want my personal assistant to remind me about about daily habits
  So that I can keep my habit
  
  Scenario: Japanese reminder - yes
    Given japanese module is enabled
      And the brain is running
      And already said hello
     When "cron study japanese" event comes
     Then pa says "japanese status request"
     When I say "yes"
     Then pa replies "good"

  Scenario: Japanese reminder - no
    Given japanese module is enabled
      And the brain is running
      And already said hello
     When "cron study japanese" event comes
     Then pa says "japanese status request"
     When I say "no"
     Then pa replies "bad"

  Scenario: Japanese reminder - anki
    Given japanese module is enabled
      And the brain is running
      And already said hello
     When I say "japanese report anki"
     Then pa replies "good"
     When "cron study japanese" event comes
     Then pa says "japanese status request duolingo"

  Scenario: Japanese reminder - duolingo
    Given japanese module is enabled
      And the brain is running
      And already said hello
     When I say "japanese report duolingo"
     Then pa replies "good"
     When "cron study japanese" event comes
     Then pa says "japanese status request anki"

  Scenario: Japanese reminder - both
    Given japanese module is enabled
      And the brain is running
      And already said hello
     When I say "japanese report duolingo"
     Then pa replies "good"
     When I say "japanese report anki"
     Then pa replies "good"
     When "cron study japanese" event comes
     Then pa says nothing

  Scenario: Japanese reminder - all
    Given japanese module is enabled
      And the brain is running
      And already said hello
     When I say "japanese report done"
     Then pa replies "good"
     When "cron study japanese" event comes
     Then pa says nothing

  Scenario: Japanese reminder - all - new day
    Given japanese module is enabled
      And the brain is running
      And already said hello
     When I say "japanese report done"
     Then pa replies "good"
     When "new day" event comes
      And "cron study japanese" event comes
     Then pa says "hello"
      And pa says "japanese status request"
