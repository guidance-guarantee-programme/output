Feature: Record of guidance preview
  As a Pension Wise guider
  I want to preview the record of guidance before it is sent
  So that I can confirm that the documents to be sent are as intended

Scenario: Standard record of guidance
  Given a customer has had a Pension Wise appointment
  When I preview their record of guidance
  Then the sections that the preview includes should be (in order):
    | covering letter          |
    | getting started          |
    | options overview         |
    | detail about each option |
    | inheritance tax          |
    | scams                    |
    | further guidance         |

Scenario: Records of guidance include the information provided to us by the customer
  Given I have captured the customer's details in an appointment summary
  When I preview their record of guidance
  Then the record of guidance preview should include their details

Scenario: Records of guidance include information about the appointment
  Given I have captured appointment details in an appointment summary
  When I preview a record of guidance
  Then the record of guidance preview should include the details of the appointment

Scenario Outline: Supplementary information can be included
  Given the customer requires supplementary information about "<topic>"
  When I preview a record of guidance
  Then the record of guidance preview should include supplementary information about "<topic>"

  Examples:
    | topic                                   |
    | Benefits and pension income             |
    | Debt and pensions                       |
    | Final salary or career average pensions |
    | Pensions and ill health                 |
