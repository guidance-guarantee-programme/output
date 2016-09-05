# frozen_string_literal: true
Given(/^I log in to regenerate a summary document$/) do
  @appointment_summary = create(:appointment_summary)
  @user = create(:team_leader).tap(&:confirm!)

  page = UserSignInPage.new
  page.login(@user)
end

When(/^I enter a customer reference number$/) do
  @page = AppointmentSummariesPage.new
  @page.load
  @page.search(@appointment_summary.reference_number)
end

When(/^I select the matched record to regenerate$/) do
  appointment = @page.appointments.first
  expect(appointment.reference_number.text).to eq(@appointment_summary.reference_number)
  appointment.regenerate_button.click
end

Then(/^I am able to edit the customers details$/) do
  @page = AppointmentSummaryPage.new
  expect(@page).to be_displayed
end

Then(/^I can regenerate the customers summary document$/) do
  @page.submit.click
  expect(@page).not_to be_displayed
end
