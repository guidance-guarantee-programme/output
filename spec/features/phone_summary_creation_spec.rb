require 'rails_helper'

RSpec.feature 'Phone guider summary creation' do
  scenario 'attempting to create a summary from scratch' do
    given_i_am_logged_in_as_a_phone_guider
    when_i_attempt_to_load_the_blank_summary_form
    then_i_am_told_to_use_tap
  end

  scenario 'creating a summary with existing data' do
    given_i_am_logged_in_as_a_phone_guider
    when_i_load_the_summary_form_with_preset_data
    and_i_fill_in_the_remaining_details
    then_i_am_able_to_submit_and_confirm_successfully
  end
end

def given_i_am_logged_in_as_a_phone_guider
  create(:user, :phone_guider)
end

def when_i_attempt_to_load_the_blank_summary_form
  @appointment_summary_page = AppointmentSummaryPage.new
  @appointment_summary_page.load
end

def when_i_load_the_summary_form_with_preset_data
  @appointment_summary_template = build(:populated_appointment_summary)

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
