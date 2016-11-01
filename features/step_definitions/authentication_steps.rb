# frozen_string_literal: true
When(/^someone visits the output application$/) do
  appointment_summary_page = AppointmentSummaryPage.new
  appointment_summary_page.load
end
