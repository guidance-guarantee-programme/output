Feature: Preview covering letter
  As a Pension Wise guider
  I want to preview the covering letter before it is sent
  So that I can confirm that the documents to be sent are as intended

Background:
  Given a new, authenticated user

Scenario: Records of guidance are sent with a covering letter
  Given a customer has had a Pension Wise appointment
  When I preview their record of guidance
  Then the preview should include a covering letter
