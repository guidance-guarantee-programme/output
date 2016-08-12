# frozen_string_literal: true
Given(/^the customer requested a (.*) appointment summary$/) do |delivery_method|
  @appointment_summary = fixture(:populated_appointment_summary).tap do |as|
    as.requested_digital = delivery_method_as_boolean(delivery_method)
  end
end

Given(/^the customer failed to receive an email notification due to an incorrect email address$/) do
  @appointment_summary = create(:appointment_summary, email: 'incorrect@email.com', requested_digital: true)
end

When(/^I create their summary document$/) do
  step('I create their record of guidance')
end

When(/^I update their email address$/) do
  @updated_email = 'correct@email.com'

  page = AppointmentSummaryBrowserPage.new
  page.load

  page.search_input.set @appointment_summary.last_name
  page.search_button.click

  page.appointments.first.edit_email.click

  page = AppointmentSummaryEditPage.new
  page.email.set @updated_email

  page.save_and_resend_email.click
end

Then(/^we should know that the customer requested a (.*) version$/) do |delivery_method|
  appointment_summary = AppointmentSummary.first
  expect(appointment_summary.requested_digital).to eq(delivery_method_as_boolean(delivery_method))
end

Then(/^the customer should be notified by email$/) do
  last_job = ActiveJob::Base.queue_adapter.enqueued_jobs.last
  expect(last_job).to eq(
    job: NotifyViaEmail,
    args: [
      { '_aj_globalid' => "gid://output/AppointmentSummary/#{AppointmentSummary.last.id}" }
    ],
    queue: 'default'
  )
end

def delivery_method_as_boolean(delivery_method)
  case delivery_method
  when 'digital' then true
  when 'postal' then false
  end
end
