@wip
Feature: Create record of guidance
  As a Pension Wise customer
  I want a record of my guidance appointment
  So that I can review my appointment in my own time without relying on memory or my own notes

  Scenario: Capture and email a record of guidance
    Given a new, authenticated user
    When appointment details are captured
    Then a record of guidance document is created
    And emailed to the customer
