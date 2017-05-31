require 'rails_helper'

RSpec.feature 'Phone guider summary creation' do
  before { ActiveJob::Base.queue_adapter.enqueued_jobs.clear }

  scenario 'attempting to create a summary from scratch' do
    given_i_am_logged_in_as_a_phone_guider
    when_i_attempt_to_load_the_blank_summary_form
    then_i_am_told_to_use_tap
  end

  scenario 'creating a summary with existing data' do
    given_i_am_logged_in_as_a_phone_guider
    when_i_complete_the_summary_form_with_preset_digital_delivery_data
    and_i_fill_in_the_remaining_details
    then_i_am_able_to_submit_and_confirm_successfully
    and_the_activity_should_be_created_on_tap
    and_the_customer_should_be_notified_by_email
  end
end

def given_i_am_logged_in_as_a_phone_guider
  @user = create(:user, :phone_guider)
end

def when_i_attempt_to_load_the_blank_summary_form
  @appointment_summary_page = AppointmentSummaryPage.new
  @appointment_summary_page.load
end

def when_i_complete_the_summary_form_with_preset_digital_delivery_data
  @appointment_summary_template = build(:populated_appointment_summary, :requested_digital)

  @appointment_summary_page = AppointmentSummaryPage.new
  @appointment_summary_page.load(@appointment_summary_template)
end

def and_i_fill_in_the_remaining_details
  @appointment_summary_page.fill_in(@appointment_summary_template)
end

def then_i_am_told_to_use_tap
  expect(@appointment_summary_page).to have_use_tap_warning
end

def then_i_am_able_to_submit_and_confirm_successfully
  @appointment_summary_page.submit.click

  @confirmation_page = ConfirmationPage.new
  @confirmation_page.confirm.click

  @done_page = DonePage.new
  expect(@done_page).to be_displayed
end

def and_the_activity_should_be_created_on_tap
  job = ActiveJob::Base.queue_adapter.enqueued_jobs[-2]
  expect(job).to eq(
    job: CreateTapActivity,
    args: [
      { '_aj_globalid' => "gid://output/AppointmentSummary/#{AppointmentSummary.last.id}" },
      { '_aj_globalid' => "gid://output/User/#{User.first.id}" }
    ],
    queue: 'default'
  )
end

def and_the_customer_should_be_notified_by_email
  job = ActiveJob::Base.queue_adapter.enqueued_jobs.last
  expect(job).to eq(
    job: NotifyViaEmail,
    args: [
      { '_aj_globalid' => "gid://output/AppointmentSummary/#{AppointmentSummary.last.id}" }
    ],
    queue: 'default'
  )
end
