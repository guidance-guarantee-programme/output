require 'rails_helper'

RSpec.feature 'Accessibility' do
  scenario 'Serving a file in standard format' do
    given_i_am_logged_in_as_a_phone_guider
    and_the_customer_prefers_to_receive_documentation_in_standard_format
    when_we_send_them_their_record_of_guidance
    then_it_should_be_in_standard_format
  end

  scenario 'Serving a file in large text format' do
    given_i_am_logged_in_as_a_phone_guider
    and_the_customer_prefers_to_receive_documentation_in_large_text_format
    when_we_send_them_their_record_of_guidance
    then_it_should_be_in_large_text_format
  end

  scenario 'Serving a file in braille format' do
    given_i_am_logged_in_as_a_phone_guider
    and_the_customer_prefers_to_receive_documentation_in_braille_format
    when_we_send_them_their_record_of_guidance
    then_it_should_be_in_braille_format
  end
end

def given_i_am_logged_in_as_a_phone_guider
  create(:user, :phone_guider)
end

def and_the_customer_prefers_to_receive_documentation_in_standard_format
  @appointment_summary = create(:populated_appointment_summary, format_preference: :standard)
end

def and_the_customer_prefers_to_receive_documentation_in_large_text_format
  @appointment_summary = create(:populated_appointment_summary, format_preference: :large_text)
end

def and_the_customer_prefers_to_receive_documentation_in_braille_format
  @appointment_summary = create(:populated_appointment_summary, format_preference: :braille)
end

def when_we_send_them_their_record_of_guidance
  appointment_summary_page = AppointmentSummaryPage.new
  appointment_summary_page.load(@appointment_summary)

  appointment_summary_page.fill_in(@appointment_summary)
  appointment_summary_page.submit.click

  confirmation_page = ConfirmationPage.new
  confirmation_page.confirm.click
end

def then_it_should_be_in_standard_format
  expect(AppointmentSummary.last).to have_attributes(format_preference: 'standard')
end

def then_it_should_be_in_large_text_format
  expect(AppointmentSummary.last).to have_attributes(format_preference: 'large_text')
end

def then_it_should_be_in_braille_format
  expect(AppointmentSummary.last).to have_attributes(format_preference: 'braille')
end
