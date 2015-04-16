Then(/^the preview should include a covering letter$/) do
  expect(page).to include_output_document_section('covering letter')

  output_document = OutputDocument.new(@appointment_summary)
  expect(page).to have_content(output_document.attendee_address)
  expect(page).to have_content(output_document.attendee_name)
  expect(page).to have_content(output_document.lead)
end
