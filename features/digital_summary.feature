Feature: Digital Appointment Summaries
  As Pension Wise
  We want to offer digital Appointment Summaries
  So the customer doesn't have to wait for the document to arrive in the post

  Scenario Outline: Request a digital appointment summary
    Given the customer <requested_digital> a digital appointment summary
    When I create their record of guidance
    Then we should know that the customer <requested_digital> a digital version

    Examples:
      | requested_digital |
      | requested         |
      | did not request   |
