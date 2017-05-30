require 'rails_helper'

RSpec.feature 'Face to face guider summary creation' do
  scenario 'creating a summary' do
    given_i_am_logged_in_as_a_face_to_face_guider
    when_i_load_the_blank_summary_form
    and_i_fill_in_the_summary_details
    then_i_am_able_to_submit_and_confirm_successfully
  end
end

def given_i_am_logged_in_as_a_face_to_face_guider
  create(:user)
end

def when_i_load_the_blank_summary_form
  @appointment_summary_page = AppointmentSummaryPage.new
  @appointment_summary_page.load
end

def and_i_fill_in_the_summary_details
  template = build(:populated_appointment_summary)
  @appointment_summary_page.fill_in(template, face_to_face: true)
end

def then_i_am_able_to_submit_and_confirm_successfully
  @appointment_summary_page.submit.click

  @confirmation_page = ConfirmationPage.new
  @confirmation_page.confirm.click

  @done_page = DonePage.new
  expect(@done_page).to be_displayed
end
