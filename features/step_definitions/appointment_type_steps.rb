# frozen_string_literal: true
Given(/^the customer is given the (.*?) appointment$/) do |appointment_type|
  @appointment_summary = fixture(:populated_appointment_summary).tap do |as|
    as.appointment_type = appointment_type.tr('-', '_')
  end
end

Then(/^it should be a (.*?) record of guidance$/) do |variant|
  expect_uploaded_csv_to_include(variant: variant.tr('-', '_'))
end
