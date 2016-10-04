Feature: Reprint Summary Document
  As a TPAS team leader
  I want to reprint a customer's summary document
  So that I can reprint it when the customer has not received the original

  @unauthenticated
  Scenario: Reprint a summary document
    Given I log in to reprint a summary document
    When I search for a reference number
    And I select the record matching the customer's details
    Then I am able to edit the customers details
    And I can reprint the customer's summary document

  @unauthenticated
  Scenario: Postal summary document requests report
    Given I log in to see a report of summary documents sent by post
    When I search for postal summary documents for today
    Then I can see the list of postal summary documents
    And I can reprint any of the summary documents for the day
