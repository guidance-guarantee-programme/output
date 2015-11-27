When(/^we send (?:them their|a) record of guidance$/) do
  appointment_summary_page = AppointmentSummaryPage.new
  appointment_summary_page.load
  appointment_summary_page.fill_in(@appointment_summary)
  appointment_summary_page.submit.click

  preview_page = PreviewPage.new
  preview_page.confirm.click

  ProcessOutputDocuments.new.call
end

Given(/^(?:I|we) have captured the customer's details in an appointment summary$/) do
  @appointment_summary = fixture(:populated_appointment_summary)
end

Then(/^the record of guidance should include their details$/) do
  expected = fixture(:populated_csv).slice(:attendee_name)

  expect_uploaded_csv_to_include(expected)
end

Given(/^(?:I|we) have captured appointment details in an appointment summary$/) do
  @appointment_summary = fixture(:populated_appointment_summary)
end
