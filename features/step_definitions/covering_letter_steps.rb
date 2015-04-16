Given(/^a customer has had a Pension Wise appointment$/) do
  @appointment_summary = fixture(:populated_appointment_summary)
end

Then(/^it should include a covering letter$/) do
  output_document = OutputDocument.new(@appointment_summary)
  expected = {
    attendee_address_line_1: output_document.attendee_address_line_1,
    attendee_address_line_2: output_document.attendee_address_line_2,
    attendee_address_line_3: output_document.attendee_address_line_3,
    attendee_town: output_document.attendee_town,
    attendee_county: output_document.attendee_county,
    attendee_postcode: output_document.attendee_postcode,
    attendee_name: output_document.attendee_name,
    lead: output_document.lead
  }

  expect_uploaded_csv_to_include(expected)
end
