# frozen_string_literal: true
Given(/^the customer (.*) a digital appointment summary$/) do |requested|
  @appointment_summary = fixture(:populated_appointment_summary).tap do |as|
    as.requested_digital = requested_as_boolean(requested)
  end
end

Then(/^we should know that the customer (.*) a digital version$/) do |requested|
  appointment_summary = AppointmentSummary.first
  expect(appointment_summary.requested_digital).to eq(requested_as_boolean(requested))
end

def requested_as_boolean(requested)
  case requested
  when 'requested' then true
  when 'did not request' then false
  end
end
