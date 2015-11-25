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

Scenario Outline: "Pension pot" section is tailored based on the range of income sources available to the customer
  Given the customer has access to income during retirement from <sources-of-income>
  When I preview their record of guidance
  Then the preview should include the "<sources-of-income>" version of the "pension pot" section

  Examples:
    | sources-of-income                   |
    | multiple sources                    |
    | only their DC pot and state pension |

Scenario: Records of guidance include the information provided to us by the customer
  Given I have captured the customer's details in an appointment summary
  When I preview their record of guidance
  Then the record of guidance preview should include their details

Scenario: Records of guidance include information about the appointment
  Given I have captured appointment details in an appointment summary
  When I preview a record of guidance
  Then the record of guidance preview should include the details of the appointment
