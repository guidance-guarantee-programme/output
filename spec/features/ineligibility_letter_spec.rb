require 'rails_helper'

RSpec.feature 'Ineligibility letter' do
  scenario 'Customers without a defined contribution pension pot receive an ineligibility letter' do
    given_i_am_logged_in_as_a_phone_guider
    and_the_customer_does_not_have_a_defined_contribution_pension_pot
    when_they_have_had_a_pension_wise_appointment
    then_we_should_send_them_an_ineligibility_letter
  end
end

def given_i_am_logged_in_as_a_phone_guider
  create(:user, :phone_guider)
end

def and_the_customer_does_not_have_a_defined_contribution_pension_pot
  @appointment_summary = create(:populated_appointment_summary, has_defined_contribution_pension: 'no')
end

def when_they_have_had_a_pension_wise_appointment
  appointment_summary_page = AppointmentSummaryPage.new
  appointment_summary_page.load(@appointment_summary)

  appointment_summary_page.fill_in(@appointment_summary)
  appointment_summary_page.submit.click

  confirmation_page = ConfirmationPage.new
  confirmation_page.confirm.click
end

def then_we_should_send_them_an_ineligibility_letter
  expect(AppointmentSummary.last).to have_attributes(has_defined_contribution_pension: 'no')
end
