@todo
Feature: Ineligibility letter
  As Pension Wise
  We want people who have Pension Wise appointments, but turn out to be ineligible, to understand why we can't help them
  So that they don't feel like the appointment was a waste of their time, and we can direct them to more appropriate sources of help

Scenario: Customers without a defined contribution pension pot receive an ineligibility letter
  Given the customer doesn't have a defined contribution pension pot
  When they have had a Pension Wise appointment
  Then we should send them an ineligibility letter
