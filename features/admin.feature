# vim: tabstop=4 expandtab shiftwidth=2 softtabstop=2
Feature: Administration
  As a personal assistant owner
  I want to be able to perform some administrative tasks
  So that I can fix personal assistant behavior without restarting it

  @wip
  Scenario: Refresh phrases
    Given the brain is running
      And already said hello
     When I say "reload phrases"
     Then translator gets "refresh" command
      And pa says "done"
