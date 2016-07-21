Feature: Summary Document delivery methods
  As a Pension Wise customer who has had a phone appointment
  I want to be able to choose between digital or postal delivery method

  Scenario Outline: Customer specified delivery method
    Given the customer requested a <delivery_method> appointment summary
    When I create their summary document
    Then we should know that the customer requested a <delivery_method> version

    Examples:
      | delivery_method |
      | digital         |
      | postal          |

  Scenario: Email notification of summary document location
    Given the customer requested a digital appointment summary
    When I create their summary document
    Then the customer should be notified by email
