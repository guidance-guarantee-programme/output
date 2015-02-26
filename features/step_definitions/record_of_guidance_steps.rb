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
