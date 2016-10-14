# frozen_string_literal: true
Given(/^I log in to reprint a summary document$/) do
  @user = create(:user, permissions: ['team_leader'])
  @appointment_summary = create(:appointment_summary)
end

Given(/^I log in to see a report of summary documents sent by post$/) do
  @user = create(:user, permissions: ['team_leader'])

  create(:appointment_summary, requested_digital: true)
  create(:appointment_summary, date_of_appointment: Time.zone.yesterday)

  @appointment_summaries = create_list(:appointment_summary, 2, requested_digital: false)
end

When(/^I search for a reference number$/) do
  @page = AppointmentSummariesPage.new
  @page.load
  @page.search(@appointment_summary.reference_number)
end

When(/^I select the record matching the customer's details$/) do
  appointment = @page.appointments.first
  expect(appointment.reference_number.text).to eq(@appointment_summary.reference_number)
  appointment.reprint_button.click
end

Then(/^I am able to edit the customers details$/) do
  @page = AppointmentSummaryPage.new
  expect(@page).to be_displayed
end

Then(/^I can reprint the customer's summary document$/) do
  @page.submit.click
  expect(@page).not_to be_displayed
end

When(/^I search for postal summary documents for today$/) do
  @page = AppointmentSummariesPage.new
  @page.load
  @page.search_date(Time.zone.today)
end

Then(/^I can see the list of postal summary documents$/) do
  reference_numbers = @page.appointments.map { |a| a.reference_number.text }
  expect(reference_numbers).to eq(@appointment_summaries.map(&:reference_number))
end

Then(/^I can reprint any of the summary documents for the day$/) do
  @page.appointments.each do |appointment_summary|
    expect(appointment_summary).to have_reprint_button
  end
end
