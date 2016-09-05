Feature: Regenerate Summary Document
  As a user
  I want to regenerate a customers summary document
  So that I can resend it when the customer has not received the original

  @unauthenticated
  Scenario: Regenerate a summary document
    Given I log in to regenerate a summary document
    When I enter a customer reference number
    And I select the matched record to regenerate
    Then I am able to edit the customers details
    And I can regenerate the customers summary document
