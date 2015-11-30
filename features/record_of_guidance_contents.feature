Feature: Record of guidance contents
  As Pension Wise
  We want to provide a record of guidance that is as tailored as possible
  So that customers are reminded of what was discussed, including next steps that they may wish to take

Scenario: Records of guidance include the information provided to us by the customer
  Given we have captured the customer's details in an appointment summary
  When we send them their record of guidance
  Then the record of guidance should include their details

Scenario Outline: Supplementary information can be included
  Given the customer requires supplementary information about "<topic>"
  When we send them their record of guidance
  Then it should include supplementary information about "<topic>"

  Examples:
    | topic                                   |
    | Benefits and pension income             |
    | Debt and pensions                       |
    | Final salary or career average pensions |
    | Pensions and ill health                 |
