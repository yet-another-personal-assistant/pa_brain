# vim: tabstop=4 expandtab shiftwidth=2 softtabstop=2
Feature: Maki-uchi
  As a personal assistant user
  I want my personal assistant to track my maki-uchi
  So that I can not track it myself

  # Can't properly test this yet
  @skip
  Scenario: Maki-uchi request
    Given maki-uchi module is enabled
      And the brain is running
     When I say "maki-uchi"
     Then pa replies "you have not done maki-uchi at all"
