require 'rails_helper'

RSpec.describe SummaryDocumentNextStepsPresenter, '#to_h' do
  let(:appointment_summary) do
    double(
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
  end

  subject { described_class.new(appointment_summary) }

  it 'maps the responses to yes/no correctly' do
    expect(subject.to_h).to eq(
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

  it 'exposes predicate methods for each next step' do
    expect(subject).not_to be_updated_beneficiaries
    expect(subject).to be_regulated_financial_advice
    expect(subject).not_to be_kept_track_of_all_pensions
    expect(subject).to be_interested_in_pension_transfer
    expect(subject).not_to be_created_retirement_budget
    expect(subject).not_to be_know_how_much_state_pension
    expect(subject).to be_received_state_benefits
    expect(subject).to be_pension_to_pay_off_debts
    expect(subject).to be_living_or_planning_overseas
    expect(subject).not_to be_finalised_a_will
    expect(subject).not_to be_setup_power_of_attorney
  end
end
