require 'rails_helper'

RSpec.feature 'Revising summary details' do
  scenario 'Going back after confirmation' do
    given_i_am_logged_in_as_a_phone_guider
    and_appointment_details_are_captured
    and_i_am_on_the_confirmation_page
    when_i_go_back_to_the_appointment_details
    then_the_previously_captured_details_are_prepopulated
  end
end

def given_i_am_logged_in_as_a_phone_guider
  create(:user, :phone_guider)
end

def and_appointment_details_are_captured
  @appointment_summary = build(:populated_appointment_summary)

  page = AppointmentSummaryPage.new
  page.load(@appointment_summary)
  page.fill_in(@appointment_summary)
  page.submit.click
end

def and_i_am_on_the_confirmation_page
  @confirmation_page = ConfirmationPage.new

  expect(@confirmation_page).to be_displayed
end

def when_i_go_back_to_the_appointment_details
  @confirmation_page.back.click
end

def then_the_previously_captured_details_are_prepopulated # rubocop:disable Metrics/MethodLength
  page = AppointmentSummaryPage.new

  text_fields = %i(title
                   first_name
                   last_name
                   address_line_1
                   address_line_2
                   address_line_3
                   town
                   county
                   postcode
                   country
                   reference_number
                   value_of_pension_pots
                   upper_value_of_pension_pots
                   guider_name)

  check_boxes = %i(value_of_pension_pots_is_approximate
                   supplementary_benefits supplementary_debt
                   supplementary_ill_health
                   supplementary_defined_benefit_pensions)

  radio_button_groups = %i(has_defined_contribution_pension
                           format_preference
                           appointment_type
                           requested_digital)

  text_fields.each do |field|
    expect(page.public_send(field).value).to eq(@appointment_summary.public_send(field).to_s)
  end

  check_boxes.each do |field|
    expect(page.public_send(field)).to have_checked_state(@appointment_summary.public_send(field))
  end

  radio_button_groups.each do |field|
    expect(page.public_send(field)).to have_selected_value(@appointment_summary.public_send(field).to_s)
  end

  expect(Time.zone.parse(page.date_of_appointment.value)).to eq(@appointment_summary.date_of_appointment)
end
