require 'rails_helper'

RSpec.feature 'Record of guidance' do
  scenario "A customer's details are recorded" do
    given_i_am_logged_in_as_a_phone_guider
    and_i_have_captured_the_customers_details_in_an_appointment_summary
    when_i_create_their_record_of_guidance
    then_the_customers_details_should_be_recorded
  end
end

def given_i_am_logged_in_as_a_phone_guider
  create(:user, :phone_guider)
end

def and_i_have_captured_the_customers_details_in_an_appointment_summary
  @appointment_summary = build(:populated_appointment_summary)
end

def when_i_create_their_record_of_guidance
  appointment_summary_page = AppointmentSummaryPage.new
  appointment_summary_page.load(@appointment_summary)
  appointment_summary_page.fill_in(@appointment_summary)
  appointment_summary_page.submit.click

  confirmation_page = ConfirmationPage.new
  confirmation_page.confirm.click
end

def then_the_customers_details_should_be_recorded
  attributes = %i(value_of_pension_pots upper_value_of_pension_pots
                  value_of_pension_pots_is_approximate count_of_pension_pots)
  appointment_summary = AppointmentSummary.first

  attributes.each do |attribute|
    expected = @appointment_summary.public_send(attribute)
    actual = appointment_summary.public_send(attribute)
    expect(actual).to eq(expected)
  end
end
