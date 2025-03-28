require 'rails_helper'

RSpec.feature 'Record of guidance contents' do
  scenario 'Records of guidance include the information provided to us by the customer' do
    given_i_am_logged_in_as_a_phone_guider
    and_i_have_captured_the_customers_details_in_an_appointment_summary
    when_we_send_them_their_record_of_guidance
    then_the_record_of_guidance_should_include_their_details
  end

  context 'supplementary information is included' do
    scenario 'about benefits and pension income' do
      given_i_am_logged_in_as_a_phone_guider
      and_the_customer_requires_supplementary_information_about('benefits and pension income')
      when_we_send_them_their_record_of_guidance
      then_it_should_include_supplementary_information_about('benefits and pension income')
    end

    scenario 'about debt and pensions' do
      given_i_am_logged_in_as_a_phone_guider
      and_the_customer_requires_supplementary_information_about('debt and pensions')
      when_we_send_them_their_record_of_guidance
      then_it_should_include_supplementary_information_about('debt and pensions')
    end

    scenario 'about final salary or career average pensions' do
      given_i_am_logged_in_as_a_phone_guider
      and_the_customer_requires_supplementary_information_about('final salary or career average pensions')
      when_we_send_them_their_record_of_guidance
      then_it_should_include_supplementary_information_about('final salary or career average pensions')
    end

    scenario 'about pensions and ill health' do
      given_i_am_logged_in_as_a_phone_guider
      and_the_customer_requires_supplementary_information_about('pensions and ill health')
      when_we_send_them_their_record_of_guidance
      then_it_should_include_supplementary_information_about('pensions and ill health')
    end

    scenario 'about transfer of pension pot' do
      given_i_am_logged_in_as_a_phone_guider
      and_the_customer_requires_supplementary_information_about('transfer of pension pot')
      when_we_send_them_their_record_of_guidance
      then_it_should_include_supplementary_information_about('transfer of pension pot')
    end
  end
end

def given_i_am_logged_in_as_a_phone_guider
  create(:user, :phone_guider)
end

def and_i_have_captured_the_customers_details_in_an_appointment_summary
  @appointment_summary = create(:populated_appointment_summary)
end

def and_the_customer_requires_supplementary_information_about(topic)
  @appointment_summary = build(:populated_appointment_summary) do |summary|
    summary.supplementary_benefits = false
    summary.supplementary_debt = false
    summary.supplementary_ill_health = false
    summary.supplementary_defined_benefit_pensions = false
    summary.supplementary_pension_transfers = false
  end

  case topic
  when 'transfer of pension pot'
    @appointment_summary.supplementary_pension_transfers = true
  end
end

def when_we_send_them_their_record_of_guidance
  appointment_summary_page = AppointmentSummaryPage.new
  appointment_summary_page.load(@appointment_summary)

  appointment_summary_page.fill_in(@appointment_summary)
  appointment_summary_page.submit.click

  confirmation_page = ConfirmationPage.new
  confirmation_page.confirm.click
end

def then_the_record_of_guidance_should_include_their_details
  expect(AppointmentSummary.last).to have_attributes(@appointment_summary.slice(:first_name, :last_name))
end

def then_it_should_include_supplementary_information_about(topic) # rubocop:disable Metrics/MethodLength
  supplementary_sections = {
    supplementary_benefits: true,
    supplementary_debt: true,
    supplementary_ill_health: true,
    supplementary_defined_benefit_pensions: true,
    supplementary_pension_transfers: false
  }

  supplementary_section = case topic
                          when 'benefits and pension income'
                            :supplementary_benefits
                          when 'debt and pensions'
                            :supplementary_debt
                          when 'pensions and ill health'
                            :supplementary_ill_health
                          when 'final salary or career average pensions'
                            :supplementary_defined_benefit_pensions
                          when 'transfer of pension pot'
                            :supplementary_pension_transfers
                          end

  supplementary_sections[supplementary_section] = true
  expect(AppointmentSummary.last).to have_attributes(supplementary_sections)
end
