Given(/^a customer has had a Pension Wise appointment$/) do
  @appointment_summary = fixture(:populated_appointment_summary)
end

Then(/^the preview should include a covering letter$/) do
  expect(page).to include_output_document_section('cover letter')

  output_document = OutputDocument.new(@appointment_summary)
  expect(page).to have_content(output_document.attendee_address)
  expect(page).to have_content(output_document.attendee_name)
  expect(page).to have_content(output_document.lead)
end
