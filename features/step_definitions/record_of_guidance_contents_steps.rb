# frozen_string_literal: true
When(/^we send them their record of guidance$/) do
  appointment_summary_page = AppointmentSummaryPage.new
  appointment_summary_page.load(@appointment_summary)

  appointment_summary_page.fill_in(@appointment_summary)
  appointment_summary_page.submit.click

  preview_page = PreviewPage.new
  preview_page.confirm.click
end

Given(/^(?:I|we) have captured the customer's details in an appointment summary$/) do
  @appointment_summary = fixture(:populated_appointment_summary)
end

Then(/^the record of guidance should include their details$/) do
  expect(AppointmentSummary.last).to have_attributes(@appointment_summary.slice(:first_name, :last_name))
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
    as.supplementary_pension_transfers = false
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
  when 'Transfer of pension pot' then
    @appointment_summary.supplementary_pension_transfers = true
  end
end

Then(/^it should include supplementary information about "(.*?)"$/) do |topic|
  supplementary_sections = {
    supplementary_benefits: false,
    supplementary_debt: false,
    supplementary_ill_health: false,
    supplementary_defined_benefit_pensions: false,
    supplementary_pension_transfers: false
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
                          when 'Transfer of pension pot' then
                            :supplementary_pension_transfers
                          end

  supplementary_sections[supplementary_section] = true
  expect(AppointmentSummary.last).to have_attributes(supplementary_sections)
end
