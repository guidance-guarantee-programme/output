# frozen_string_literal: true
Given(/^"(.*?)" applies to the customer$/) do |circumstance|
  @appointment_summary = fixture(:populated_appointment_summary).tap do |as|
    as.continue_working = false
    as.unsure = false
    as.leave_inheritance = false
    as.wants_flexibility = false
    as.wants_security = false
    as.wants_lump_sum = false
    as.poor_health = false
  end

  case circumstance
  when 'Plans to continue working for a while' then @appointment_summary.continue_working = true
  when 'Unsure about plans in retirement'      then @appointment_summary.unsure = true
  when 'Plans to leave money to someone'       then @appointment_summary.leave_inheritance = true
  when 'Wants flexibility when taking money'   then @appointment_summary.wants_flexibility = true
  when 'Wants a guaranteed income'             then @appointment_summary.wants_security = true
  when 'Needs a certain amount of money now'   then @appointment_summary.wants_lump_sum = true
  when 'Has poor health'                       then @appointment_summary.poor_health = true
  end
end

When(/^I create their record of guidance$/) do
  appointment_summary_page = AppointmentSummaryPage.new
  appointment_summary_page.load(@appointment_summary)
  appointment_summary_page.fill_in(@appointment_summary)
  appointment_summary_page.submit.click

  confirmation_page = ConfirmationPage.new
  confirmation_page.confirm.click
end

Then(/^information about "(.*?)" should be recorded$/) do |circumstance|
  attribute = case circumstance
              when 'Plans to continue working for a while' then :continue_working
              when 'Unsure about plans in retirement'      then :unsure
              when 'Plans to leave money to someone'       then :leave_inheritance
              when 'Wants flexibility when taking money'   then :wants_flexibility
              when 'Wants a guaranteed income'             then :wants_security
              when 'Needs a certain amount of money now'   then :wants_lump_sum
              when 'Has poor health'                       then :poor_health
              end

  appointment_summary = AppointmentSummary.first
  expect(appointment_summary.public_send(attribute)).to be_truthy
end

Then(/^the customer's details should be recorded$/) do
  attributes = %i(value_of_pension_pots upper_value_of_pension_pots
                  value_of_pension_pots_is_approximate count_of_pension_pots)
  appointment_summary = AppointmentSummary.first

  attributes.each do |attribute|
    expected = @appointment_summary.public_send(attribute)
    actual = appointment_summary.public_send(attribute)
    expect(actual).to eq(expected)
  end
end
