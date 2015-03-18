When(/^appointment details are captured$/) do
  page = AppointmentSummaryPage.new
  page.load
  page.name.set 'Joe Bloggs'
  page.email_address.set 'joe.bloggs@example.com'
  page.address.set "HM Treasury\n1 Horse Guards Road\nLondon\nSW1A 2HQ"
  page.date_of_appointment.set '05/02/2015'
  page.value_of_pension_pots.set 35_000
  page.income_in_retirement_pension.set true
  page.guider_name.set 'Alex Leahy'
  page.guider_organisation_tpas.set true
  page.continue_working.set true
  page.unsure.set true
  page.leave_inheritance.set true
  page.wants_flexibility.set true
  page.wants_security.set true
  page.wants_lump_sum.set true
  page.poor_health.set true
  page.submit.click
end

When(/^I preview the record of guidance document$/) do
  expect(AppointmentSummary.count).to eq(0)

  page = RecordOfGuidancePreviewPage.new
  expect(page).to be_displayed
  expect(page.name.text).to eql('Joe Bloggs')

  page.confirm.click
end

Then(/^a record of guidance document is created$/) do
  appointment_summary = AppointmentSummary.last

  expect(appointment_summary.name).to eql('Joe Bloggs')
  expect(appointment_summary.email_address).to eql('joe.bloggs@example.com')
end
