require 'rails_helper'

RSpec.describe AppointmentSummary, type: :model do
  let(:continue_working) { false }
  let(:has_defined_contribution_pension) { 'no' }
  let(:params) do
    {
      has_defined_contribution_pension: has_defined_contribution_pension,
      continue_working: continue_working
    }
  end

  subject { described_class.new(params) }

  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to_not validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }

  it { is_expected.to allow_value('Mr').for(:title) }
  it { is_expected.to_not allow_value('Alien').for(:title) }

  it { is_expected.to allow_value('2015-02-10').for(:date_of_appointment) }
  it { is_expected.to allow_value('12/02/2015').for(:date_of_appointment) }
  it { is_expected.to_not allow_value('10/02/2012').for(:date_of_appointment) }
  it { is_expected.to_not allow_value(Date.tomorrow.to_s).for(:date_of_appointment) }

  it { is_expected.to validate_presence_of(:reference_number) }
  it { is_expected.to validate_numericality_of(:reference_number) }

  it { is_expected.to_not validate_presence_of(:value_of_pension_pots) }
  it { is_expected.to validate_numericality_of(:value_of_pension_pots) }
  it { is_expected.to allow_value('').for(:value_of_pension_pots) }

  it { is_expected.to_not validate_presence_of(:upper_value_of_pension_pots) }
  it { is_expected.to validate_numericality_of(:upper_value_of_pension_pots) }
  it { is_expected.to allow_value('').for(:upper_value_of_pension_pots) }

  it { is_expected.to validate_inclusion_of(:income_in_retirement).in_array(%w(pension other)) }

  it { is_expected.to validate_presence_of(:guider_name) }
  it { is_expected.to validate_inclusion_of(:guider_organisation).in_array(%w(tpas dwp)) }

  it { is_expected.to validate_presence_of(:address_line_1) }
  it { is_expected.to_not validate_presence_of(:address_line_2) }
  it { is_expected.to_not validate_presence_of(:address_line_3) }
  it { is_expected.to validate_presence_of(:town) }
  it { is_expected.to_not validate_presence_of(:county) }
  it { is_expected.to validate_presence_of(:postcode) }
  it { is_expected.to allow_value('sw1a 2hq').for(:postcode) }
  it { is_expected.to allow_value('SW1A 2HQ').for(:postcode) }
  it { is_expected.to allow_value('SW1A2HQ').for(:postcode) }
  it { is_expected.to allow_value(' SW1A 2HQ    ').for(:postcode) }
  it { is_expected.to_not allow_value('SW1A2H').for(:postcode) }
  it { is_expected.to_not allow_value('SWIA2HQ').for(:postcode) }

  it do
    is_expected
      .to validate_inclusion_of(:has_defined_contribution_pension).in_array(%w(yes no unknown))
  end

  it do
    is_expected
      .to validate_inclusion_of(:format_preference).in_array(%w(standard large_text braille))
  end

  context 'when ineligible for guidance' do
    it { is_expected.to_not be_eligible_for_guidance }
    it { is_expected.to_not be_generic_guidance }
    it { is_expected.to_not be_custom_guidance }
  end

  context 'when eligible for guidance' do
    let(:has_defined_contribution_pension) { 'yes' }

    context 'and no retirement circumstances given' do
      it { is_expected.to be_eligible_for_guidance }
      it { is_expected.to be_generic_guidance }
      it { is_expected.to_not be_custom_guidance }
    end

    context 'and retirement circumstances given' do
      let(:continue_working) { true }

      it { is_expected.to be_eligible_for_guidance }
      it { is_expected.to_not be_generic_guidance }
      it { is_expected.to be_custom_guidance }
    end
  end
end
