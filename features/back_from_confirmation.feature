Feature: Back from confirmation
  As a guidance specialist
  I want to modify details of an output document
  So that I can easily correct errors before the output document is sent

Scenario: Back from confirming an output document
  Given appointment details are captured
  And I'm on the confirmation page
  When I go back to the appointment details
  Then the previously captured details are prepopulated
