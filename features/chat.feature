# vim: tabstop=4 expandtab shiftwidth=2 softtabstop=2
Feature: Chatting with the brain
  As a personal assistant user
  I want to be able to chat to my personal assistant
  So that it responds to my phrases

  Scenario: Greeting
    Given the brain is running
     When I say "hello"
     Then pa replies "hello"

  Scenario: First phrase greeting
    Given the brain is running
     When I say "yo"
     Then pa replies "hello"
