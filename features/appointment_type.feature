Feature: Appointment type
  As Pension Wise
  We want to offer tailored appointments to customers
  So we can provide relevant information where possible

  Scenario Outline: Appointment types
    Given the customer is given the <type> appointment
    When we send them their record of guidance
    Then it should be a <variant> record of guidance

    Examples:
      | type     | variant  |
      | standard | standard |
      | 50-54    | 50-54    |
