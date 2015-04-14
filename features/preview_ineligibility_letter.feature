Feature: Preview ineligibility letter
  As a Pension Wise guider
  I want to preview ineligibility letters before they are sent
  So that I can confirm that the documents to be sent are as intended

Background:
  Given a new, authenticated user

Scenario: Customers without a defined contribution pension pot receive an ineligibility letter
  Given the customer doesn't have a defined contribution pension pot
  When I preview their record of guidance
  Then the preview should show an ineligibility letter
