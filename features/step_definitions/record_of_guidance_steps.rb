When(/^appointment details are captured$/) do
  page = AppointmentSummaryPage.new
  page.load
  page.name.set 'Joe Bloggs'
  page.email_address.set 'joe.bloggs@example.com'
  page.date_of_appointment.set '05/02/2015'
  page.value_of_pension_pots.set 35_000
  page.income_in_retirement_pension.set true
  page.guider_name.set 'Alex Leahy'
  page.guider_organisation_tpas.set true
  page.submit.click

  appointment_summary = AppointmentSummary.last

  expect(appointment_summary.name).to eql('Joe Bloggs')
  expect(appointment_summary.email_address).to eql('joe.bloggs@example.com')
end

Then(/^a record of guidance document is created$/) do
  text = PDF::Inspector::Text.analyze(page.source).strings.join

  expect(page.response_headers['Content-Type']).to eql('application/pdf')
  expect(text).to include('Joe Bloggs')
  expect(text).to include('February 5, 2015')
  expect(text).to include('£35,000')
end

Then(/^emailed to the customer$/) do
  expect(ActiveJob::Base.queue_adapter.enqueued_jobs.first[:job]).to eql(OutputDocumentMailerJob)
end
