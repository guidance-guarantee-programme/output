Feature: Back from preview
  As a guidance specialist
  I want to modify details of a previewed output document
  So that I can easily correct errors before the output document is sent

Scenario: Back from previewing an output document
  Given appointment details are captured
  And I'm on the preview page
  When I go back to the appointment details
  Then the previously captured details are prepopulated
