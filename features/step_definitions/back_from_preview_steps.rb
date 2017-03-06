# frozen_string_literal: true
Given(/^appointment details are captured$/) do
  @appointment_summary = fixture(:populated_appointment_summary)

  page = AppointmentSummaryPage.new
  page.load(@appointment_summary)
  page.fill_in(@appointment_summary)
  page.submit.click

  email_confirmation_page = EmailConfirmationPage.new
  email_confirmation_page.confirm.click
end

Given(/^I'm on the preview page$/) do
  page = PreviewPage.new

  expect(page).to be_displayed
end

When(/^I go back to the appointment details$/) do
  page = PreviewPage.new

  page.back.click
end

Then(/^the previously captured details are prepopulated$/) do # rubocop:disable Metrics/BlockLength
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
                   continue_working
                   unsure
                   leave_inheritance
                   wants_flexibility
                   wants_security
                   wants_lump_sum
                   poor_health
                   supplementary_benefits supplementary_debt
                   supplementary_ill_health
                   supplementary_defined_benefit_pensions
                   retirement_income_other_state_benefits
                   retirement_income_employment
                   retirement_income_partner
                   retirement_income_interest_or_savings
                   retirement_income_property
                   retirement_income_business
                   retirement_income_inheritance
                   retirement_income_other_income
                   retirement_income_unspecified)

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
