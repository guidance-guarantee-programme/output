require 'rails_helper'

RSpec.feature 'Face to face guider summary creation' do
  before { ActiveJob::Base.queue_adapter.enqueued_jobs.clear }

  scenario 'creating a summary' do
    given_i_am_logged_in_as_a_face_to_face_guider
    when_i_load_the_blank_summary_form
    and_i_complete_the_summary_form_with_preset_digital_delivery_data
    then_i_am_able_to_submit_and_confirm_successfully
    and_the_customer_should_be_notified_by_email
    and_no_activity_should_be_created_on_tap
  end
end

def given_i_am_logged_in_as_a_face_to_face_guider
  create(:user)
end

def when_i_load_the_blank_summary_form
  @appointment_summary_page = AppointmentSummaryPage.new
  @appointment_summary_page.load
end

def and_i_complete_the_summary_form_with_preset_digital_delivery_data
  template = build(:populated_appointment_summary, :requested_digital)
  @appointment_summary_page.fill_in(template, face_to_face: true)
end

def then_i_am_able_to_submit_and_confirm_successfully
  @appointment_summary_page.submit.click

  @confirmation_page = ConfirmationPage.new
  @confirmation_page.confirm.click

  @done_page = DonePage.new
  expect(@done_page).to be_displayed
end

def and_the_customer_should_be_notified_by_email
  assert_enqueued_jobs 1, only: NotifyViaEmail
end

def and_no_activity_should_be_created_on_tap
  assert_enqueued_jobs 0, only: CreateTapActivity
end
