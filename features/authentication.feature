@unauthenticated
Feature: Authentication
  As Pension Wise
  We want users to log in before they can access the output application
  So that we have control over who can send output documents

Scenario: Unauthenticated access gets redirected to a login page
  When someone visits the output application
  Then they are presented with a login page
