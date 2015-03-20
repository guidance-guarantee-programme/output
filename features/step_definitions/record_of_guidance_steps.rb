When(/^appointment details are captured$/) do
  page = AppointmentSummaryPage.new
  page.load
  page.title.select 'Mr'
  page.first_name.set 'Joe'
  page.last_name.set 'Bloggs'
  page.address_line_1.set 'HM Treasury'
  page.address_line_2.set '1 Horse Guards Road'
  page.town.set 'London'
  page.postcode.set 'SW1A 2HQ'
  page.date_of_appointment.set '05/02/2015'
  page.reference_number.set '98212'
  page.value_of_pension_pots.set 35_000
  page.upper_value_of_pension_pots.set 55_000
  page.income_in_retirement_pension.set true
  page.guider_name.set 'Alex Leahy'
  page.guider_organisation_tpas.set true
  page.has_defined_contribution_pension_yes.set true
  page.continue_working.set true
  page.unsure.set true
  page.leave_inheritance.set true
  page.wants_flexibility.set true
  page.wants_security.set true
  page.wants_lump_sum.set true
  page.poor_health.set true
  page.format_preference_standard.set true
  page.submit.click
end

When(/^I preview the record of guidance document$/) do
  expect(AppointmentSummary.count).to eq(0)
  page = RecordOfGuidancePreviewPage.new
  expect(page).to be_displayed
  expect(page.name.text).to eql('Mr Joe Bloggs')

  page.confirm.click
end

Then(/^a record of guidance document is created$/) do
  appointment_summary = AppointmentSummary.last

  expect(appointment_summary.title).to eql('Mr')
  expect(appointment_summary.first_name).to eql('Joe')
  expect(appointment_summary.last_name).to eql('Bloggs')
  expect(appointment_summary.address_line_1).to eql('HM Treasury')
  expect(appointment_summary.address_line_2).to eql('1 Horse Guards Road')
  expect(appointment_summary.town).to eql('London')
  expect(appointment_summary.postcode).to eql('SW1A 2HQ')
  expect(appointment_summary.reference_number).to eql('98212')
  expect(appointment_summary.has_defined_contribution_pension).to eql('yes')
  expect(appointment_summary.format_preference).to eql('standard')
  expect(appointment_summary.value_of_pension_pots).to eql(35_000)
  expect(appointment_summary.upper_value_of_pension_pots).to eql(55_000)
end
