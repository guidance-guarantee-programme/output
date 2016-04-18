# frozen_string_literal: true
Given(/^a customer has had a Pension Wise appointment$/) do
  @appointment_summary = fixture(:populated_appointment_summary)
end

Then(/^it should include a covering letter$/) do
  expected = fixture(:populated_csv).slice(*%i(attendee_address_line_1
                                               attendee_address_line_2
                                               attendee_address_line_3
                                               attendee_town
                                               attendee_county
                                               attendee_postcode
                                               attendee_name
                                               lead))

  expect_uploaded_csv_to_include(expected)
end
