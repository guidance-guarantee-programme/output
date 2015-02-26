When(/^appointment details are captured$/) do
  page = AppointmentSummaryPage.new
  page.load
  page.name.set 'Joe Bloggs'
  page.email_address.set 'joe.bloggs@example.com'
  page.submit.click

  appointment_summary = AppointmentSummary.last

  expect(appointment_summary.name).to eql('Joe Bloggs')
  expect(appointment_summary.email_address).to eql('joe.bloggs@example.com')
end

Then(/^a record of guidance document is created$/) do
  expect(page.response_headers['Content-Type']).to eql('application/pdf')
  text = PDF::Inspector::Text.analyze(page.source).strings.join
  expect(text).to include('Joe Bloggs')
end
