@signon
Feature: Appointment Summary Browser
  As a Pension Wise Administrator
  I want to browse Appointment Summaries
  So that I can self serve

Scenario: Viewing the Appointment Summaries
  Given I am logged in as a Pension Wise Administrator
  When I visit the Summary Browser
  Then I am presented with a table of Appointment Summaries
