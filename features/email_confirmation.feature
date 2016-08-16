Feature: Email confirmation
  As Pension Wise
  We want the guider to perform a secondary check on the customers email address they have entered
  To improve the accuracy of the email and ensure the customer is notified

  Scenario: Confirm email address
    Given a guider has submitted the customer's details in an appointment summary
    When they confirm the email address is correctly entered
    And they confirm the preview of the appointment
    Then the confirmed email address is saved

  Scenario: Edit incorrect email during email confirmation
    Given a guider has submitted the customer's details in an appointment summary
    When they correct the email address during the confirmation step
    And they confirm the preview of the appointment
    Then the confirmed email address is saved
