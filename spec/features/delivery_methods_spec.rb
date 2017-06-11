require 'rails_helper'

RSpec.feature 'Summary Document delivery methods' do
  scenario 'Digital delivery' do
    given_i_am_logged_in_as_a_phone_guider
    and_the_customer_requested_a_digital_appointment_summary
    when_i_create_their_summary_document
    then_we_should_know_that_the_customer_requested_a_digital_version
  end

  scenario 'Postal delivery' do
    given_i_am_logged_in_as_a_phone_guider
    and_the_customer_requested_a_postal_appointment_summary
    when_i_create_their_summary_document
    then_we_should_know_that_the_customer_requested_a_postal_version
  end
end

def given_i_am_logged_in_as_a_phone_guider
  create(:user, :phone_guider)
end

def and_the_customer_requested_a_digital_appointment_summary
  @appointment_summary = create(:populated_appointment_summary, requested_digital: true)
end

def and_the_customer_requested_a_postal_appointment_summary
  @appointment_summary = create(:populated_appointment_summary, requested_digital: false)
end

def when_i_create_their_summary_document
  appointment_summary_page = AppointmentSummaryPage.new
  appointment_summary_page.load(@appointment_summary)
  appointment_summary_page.fill_in(@appointment_summary)
  appointment_summary_page.submit.click

  confirmation_page = ConfirmationPage.new
  confirmation_page.confirm.click
end

def then_we_should_know_that_the_customer_requested_a_digital_version
  appointment_summary = AppointmentSummary.first
  expect(appointment_summary.requested_digital).to eq true
end

def then_we_should_know_that_the_customer_requested_a_postal_version
  appointment_summary = AppointmentSummary.first
  expect(appointment_summary.requested_digital).to eq false
end
