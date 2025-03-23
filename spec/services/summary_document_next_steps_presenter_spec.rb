require 'rails_helper'

RSpec.describe SummaryDocumentNextStepsPresenter, '#to_h' do
  it 'maps the responses to yes/no correctly' do
    @appointment_summary = double(
      updated_beneficiaries: 'yes',
      regulated_financial_advice: 'yes',
      kept_track_of_all_pensions: 'yes',
      interested_in_pension_transfer: 'yes',
      created_retirement_budget: 'yes',
      know_how_much_state_pension: 'yes',
      received_state_benefits: 'yes',
      pension_to_pay_off_debts: 'yes',
      living_or_planning_overseas: 'yes',
      finalised_a_will: 'yes',
      setup_power_of_attorney: 'yes'
    )

    expect(described_class.new(@appointment_summary).to_h).to eq(
      {
        updated_beneficiaries: 'no',
        regulated_financial_advice: 'yes',
        kept_track_of_all_pensions: 'no',
        interested_in_pension_transfer: 'yes',
        created_retirement_budget: 'no',
        know_how_much_state_pension: 'no',
        received_state_benefits: 'yes',
        pension_to_pay_off_debts: 'yes',
        living_or_planning_overseas: 'yes',
        finalised_a_will: 'no',
        setup_power_of_attorney: 'no'
      }
    )
  end
end
