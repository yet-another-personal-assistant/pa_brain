# vim: tabstop=4 expandtab shiftwidth=2 softtabstop=2
Feature: Unknown words
  As a personal assistant user
  I want my personal assistant to tell me if it doesn't understand me
  So that I can fix my phrase

  Scenario: Unintelligible
    Given the brain is running
      And already said hello
     When I say "unintelligible something"
     Then pa replies "failed to parse"

  Scenario: Some unknown command
    Given the brain is running
      And already said hello
     When I say "here comes a command"
     Then pa replies "unknown command "here comes a command""

  Scenario: Unintelligible with greeting
    Given the brain is running
     When I say "unintelligible something"
     Then pa replies "hello"
      And pa says "failed to parse"

  Scenario: Some unknown command with greeting
    Given the brain is running
     When I say "here comes a command"
     Then pa replies "hello"
      And pa says "unknown command "here comes a command""
