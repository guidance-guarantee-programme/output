Feature: Appointment Summary Browser
  As a Pension Wise Administrator
  I want to browse Appointment Summaries
  So that I can self serve

@unauthenticated
Scenario: Viewing the Appointment Summaries
  Given I am logged in as a Pension Wise Administrator
  And there are existing Appointment Summaries
  When I visit the Summary Browser
  Then I am presented with Appointment Summaries
  And I see there are multiple pages
  And the date range is displayed

@unauthenticated
Scenario: Exporting the Appointment Summaries to CSV
  Given I am logged in as a Pension Wise Administrator
  And there are existing Appointment Summaries
  When I visit the Summary Browser
  And I export the results to CSV
  Then I am prompted to download a CSV

Scenario: Attempting to view the Appointment Summaries
  When I visit the Summary Browser
  Then I am denied access
