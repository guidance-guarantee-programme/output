Then(/^the preview should show an ineligibility letter$/) do
  expect(page).to include_output_document_sections(['ineligible'])

  output_document = OutputDocument.new(@appointment_summary)
  expect(page).to have_content(output_document.attendee_address)
  expect(page).to have_content(output_document.attendee_name)
  expect(page).to have_content(output_document.lead)
end
