# frozen_string_literal: true
When(/^we send (?:them their|a) record of guidance$/) do
  appointment_summary_page = AppointmentSummaryPage.new
  appointment_summary_page.load
  appointment_summary_page.fill_in(@appointment_summary)
  appointment_summary_page.submit.click

  email_confirmation_page = EmailConfirmationPage.new
  email_confirmation_page.confirm.click

  preview_page = PreviewPage.new
  preview_page.confirm.click

  ProcessOutputDocuments.new.call
end

Given(/^(?:I|we) have captured the customer's details in an appointment summary$/) do
  @appointment_summary = fixture(:populated_appointment_summary)
end

Then(/^the record of guidance should include their details$/) do
  expected = fixture(:populated_csv).slice(:attendee_name)

  expect_uploaded_csv_to_include(expected)
end

Given(/^(?:I|we) have captured appointment details in an appointment summary$/) do
  @appointment_summary = fixture(:populated_appointment_summary)
end

Given(/^the customer requires supplementary information about "([^"]*)"$/) do |topic|
  @appointment_summary = fixture(:populated_appointment_summary).tap do |as|
    as.supplementary_benefits = false
    as.supplementary_debt = false
    as.supplementary_ill_health = false
    as.supplementary_defined_benefit_pensions = false
  end

  case topic
  when 'Benefits and pension income' then
    @appointment_summary.supplementary_benefits = true
  when 'Debt and pensions' then
    @appointment_summary.supplementary_debt = true
  when 'Pensions and ill health' then
    @appointment_summary.supplementary_ill_health = true
  when 'Final salary or career average pensions' then
    @appointment_summary.supplementary_defined_benefit_pensions = true
  end
end

Then(/^it should include supplementary information about "(.*?)"$/) do |topic|
  supplementary_sections = {
    supplementary_benefits: false,
    supplementary_debt: false,
    supplementary_ill_health: false,
    supplementary_defined_benefit_pensions: false
  }

  supplementary_section = case topic
                          when 'Benefits and pension income' then
                            :supplementary_benefits
                          when 'Debt and pensions' then
                            :supplementary_debt
                          when 'Pensions and ill health' then
                            :supplementary_ill_health
                          when 'Final salary or career average pensions' then
                            :supplementary_defined_benefit_pensions
                          end

  supplementary_sections[supplementary_section] = true
  expect_uploaded_csv_to_include(supplementary_sections)
end
