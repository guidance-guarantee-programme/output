require 'rails_helper'

RSpec.feature 'Record of guidance' do
  scenario "A customer's details are recorded" do
    given_i_am_logged_in_as_a_phone_guider
    and_i_have_captured_the_customers_details_in_an_appointment_summary
    when_i_create_their_record_of_guidance
    then_the_customers_details_should_be_recorded
  end

  context "Recording of customers' individual circumstances" do
    scenario 'when they plan to continue working for a while' do
      given_i_am_logged_in_as_a_phone_guider
      and_the_customer('plans to continue working for a while')
      when_i_create_their_record_of_guidance
      then_information_it_should_be_recorded_that('plans to continue working for a while')
    end

    scenario 'when they are unsure about plans in retirement' do
      given_i_am_logged_in_as_a_phone_guider
      and_the_customer('is unsure about plans in retirement')
      when_i_create_their_record_of_guidance
      then_information_it_should_be_recorded_that('is unsure about plans in retirement')
    end

    scenario 'when they plan to leave money to someone' do
      given_i_am_logged_in_as_a_phone_guider
      and_the_customer('plans to leave money to someone')
      when_i_create_their_record_of_guidance
      then_information_it_should_be_recorded_that('plans to leave money to someone')
    end

    scenario 'when they want flexibility when taking money' do
      given_i_am_logged_in_as_a_phone_guider
      and_the_customer('wants flexibility when taking money')
      when_i_create_their_record_of_guidance
      then_information_it_should_be_recorded_that('wants flexibility when taking money')
    end

    scenario 'when they want a guaranteed income' do
      given_i_am_logged_in_as_a_phone_guider
      and_the_customer('wants a guaranteed income')
      when_i_create_their_record_of_guidance
      then_information_it_should_be_recorded_that('wants a guaranteed income')
    end

    scenario 'when they need a certain amount of money now' do
      given_i_am_logged_in_as_a_phone_guider
      and_the_customer('needs a certain amount of money now')
      when_i_create_their_record_of_guidance
      then_information_it_should_be_recorded_that('needs a certain amount of money now')
    end

    scenario 'when they have poor health' do
      given_i_am_logged_in_as_a_phone_guider
      and_the_customer('has poor health')
      when_i_create_their_record_of_guidance
      then_information_it_should_be_recorded_that('has poor health')
    end
  end
end

def given_i_am_logged_in_as_a_phone_guider
  create(:user, :phone_guider)
end

def and_i_have_captured_the_customers_details_in_an_appointment_summary
  @appointment_summary = build(:populated_appointment_summary)
end

def and_the_customer(circumstances) # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
  @appointment_summary = build(:populated_appointment_summary) do |summary|
    summary.continue_working = false
    summary.unsure = false
    summary.leave_inheritance = false
    summary.wants_flexibility = false
    summary.wants_security = false
    summary.wants_lump_sum = false
    summary.poor_health = false
  end

  case circumstances
  when 'plans to continue working for a while' then @appointment_summary.continue_working = true
  when 'is unsure about plans in retirement'   then @appointment_summary.unsure = true
  when 'plans to leave money to someone'       then @appointment_summary.leave_inheritance = true
  when 'wants flexibility when taking money'   then @appointment_summary.wants_flexibility = true
  when 'wants a guaranteed income'             then @appointment_summary.wants_security = true
  when 'needs a certain amount of money now'   then @appointment_summary.wants_lump_sum = true
  when 'has poor health'                       then @appointment_summary.poor_health = true
  end
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

def then_information_it_should_be_recorded_that(circumsances) # rubocop:disable Metrics/CyclomaticComplexity
  attribute = case circumsances
              when 'plans to continue working for a while' then :continue_working
              when 'is unsure about plans in retirement'   then :unsure
              when 'plans to leave money to someone'       then :leave_inheritance
              when 'wants flexibility when taking money'   then :wants_flexibility
              when 'wants a guaranteed income'             then :wants_security
              when 'needs a certain amount of money now'   then :wants_lump_sum
              when 'has poor health'                       then :poor_health
              end

  appointment_summary = AppointmentSummary.first
  expect(appointment_summary.public_send(attribute)).to be_truthy
end
