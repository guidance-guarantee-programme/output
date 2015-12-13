Feature: Record of guidance
  As Pension Wise
  We want to capture what was discussed with the customer
  So that we can analyse the data later

Scenario Outline: Individual circumstances are recorded
  Given "<circumstance>" applies to the customer
  When I create their record of guidance
  Then information about "<circumstance>" should be recorded

  Examples:
    | circumstance                          |
    | Plans to continue working for a while |
    | Unsure about plans in retirement      |
    | Plans to leave money to someone       |
    | Wants flexibility when taking money   |
    | Wants a guaranteed income             |
    | Needs a certain amount of money now   |
    | Has poor health                       |

Scenario: Customer's details are recorded
  Given I have captured the customer's details in an appointment summary
  When I create their record of guidance
  Then the customer's details should be recorded
