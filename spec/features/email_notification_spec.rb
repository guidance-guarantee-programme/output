require 'rails_helper'

RSpec.feature 'Email notification' do
  scenario 'Email notification of summary document location' do
    given_the_customer_requested_a_digital_appointment_summary
    when_i_create_their_summary_document
    then_the_customer_should_be_notified_by_email
  end

  scenario 'Resending email after correction of email address' do
    given_i_am_logged_in_as_a_pension_wise_administrator
    and_the_customer_failed_to_receive_an_email_notification_due_to_an_incorrect_email_address
    when_i_update_their_email_address
    then_the_customer_should_be_notified_by_email
  end
end

def given_the_customer_requested_a_digital_appointment_summary
  @appointment_summary = create(:populated_appointment_summary, requested_digital: true)
end

def given_i_am_logged_in_as_a_pension_wise_administrator
  create(:user, permissions: ['analyst'])
end

def and_the_customer_failed_to_receive_an_email_notification_due_to_an_incorrect_email_address
  @appointment_summary = create(:appointment_summary, email: 'incorrect@email.com', requested_digital: true)
end

def when_i_create_their_summary_document
  appointment_summary_page = AppointmentSummaryPage.new
  appointment_summary_page.load(@appointment_summary)
  appointment_summary_page.fill_in(@appointment_summary)
  appointment_summary_page.submit.click

  confirmation_page = ConfirmationPage.new
  confirmation_page.confirm.click
end

def when_i_update_their_email_address
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

def then_the_customer_should_be_notified_by_email
  last_job = ActiveJob::Base.queue_adapter.enqueued_jobs.last
  expect(last_job).to eq(
    job: NotifyViaEmail,
    args: [
      { '_aj_globalid' => "gid://output/AppointmentSummary/#{AppointmentSummary.last.id}" }
    ],
    queue: 'default'
  )
end
