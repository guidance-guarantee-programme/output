When(/^appointment details are captured$/) do
  allow(OutputDocument).to receive(:new).and_return(double(pdf: ''))

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
end

Then(/^emailed to the customer$/) do
  expect(ActiveJob::Base.queue_adapter.enqueued_jobs.first[:job]).to eql(OutputDocumentMailerJob)
end
