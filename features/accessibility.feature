Feature: Accessibility
  As Pension Wise
  We want the service to be accessible to as many people as possible
  So that no one is excluded

Scenario Outline: Document formats
  Given the customer prefers to receive documentation in <format> format
  When we send them documentation
  Then it should be in <format> format

  Examples:
  | format     |
  | standard   |
  | large text |
  | braille    |
