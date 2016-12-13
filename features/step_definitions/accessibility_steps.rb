# frozen_string_literal: true
Given(/^the customer prefers to receive documentation in (.*?) format$/) do |format_preference|
  @appointment_summary = fixture(:populated_appointment_summary).tap do |as|
    as.format_preference = format_preference.gsub(/\s+/, '_')
  end
end

Then(/^it should be in (.*?) format$/) do |format_preference|
  expect(AppointmentSummary.last).to have_attributes(format_preference: format_preference.gsub(/\s+/, '_'))
end

Then(/^we should not send them any documentation, for now$/) do
  step('we send them their record of guidance')
end
