Feature: Email notification
  As a Pension Wise employee
  When the customer selected a digital summary document
  I want to ensure the customer receives a notification email

  Scenario: Email notification of summary document location
    Given the customer requested a digital appointment summary
    When I create their summary document
    Then the customer should be notified by email

  @unauthenticated
  Scenario: Resending email after correction of email address
    Given I am logged in as a Pension Wise Administrator
    And the customer failed to receive an email notification due to an incorrect email address
    When I update their email address
    Then the customer should be notified by email
