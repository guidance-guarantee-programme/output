Given(/^the customer doesn't have a defined contribution pension pot$/) do
  @appointment_summary = fixture(:populated_appointment_summary).tap do |as|
    as.has_defined_contribution_pension = 'no'
  end
end

When(/^they have had a Pension Wise appointment$/) do
  step('we send them their record of guidance')
end

Then(/^we should send them an ineligibility letter$/) do
  expect_uploaded_csv_to_include(variant: 'other')
end
