require 'rails_helper'

RSpec.feature 'Face to face guider summary creation' do
  scenario 'creating a summary' do
    given_i_am_logged_in_as_a_face_to_face_guider
    when_i_load_the_blank_summary_form
    then_i_am_able_to_see_the_form
  end
end

def given_i_am_logged_in_as_a_face_to_face_guider
  create(:user)
end

def when_i_load_the_blank_summary_form
  @appointment_summary_page = AppointmentSummaryPage.new
  @appointment_summary_page.load
end

def then_i_am_able_to_see_the_form
  expect(@appointment_summary_page).to have_submit
end
