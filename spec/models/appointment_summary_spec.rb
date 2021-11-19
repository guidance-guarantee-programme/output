require 'rails_helper'

RSpec.describe AppointmentSummary, type: :model do
  subject do
    described_class.new(has_defined_contribution_pension: has_defined_contribution_pension)
  end

  it 'defaults to the Pension Wise schedule type' do
    expect(subject).to be_pension_wise
  end

  context 'when due diligence' do
    before do
      subject.schedule_type = 'due_diligence'
      subject.title = 'Mr'
      subject.last_name = 'James'
      subject.date_of_appointment = '2021-09-29'
      subject.reference_number = '123456'
      subject.email = 'dave@example.com'
    end

    it 'can be categorised as a due diligence appointment' do
      expect(subject).to be_due_diligence
    end

    it 'defaults `has_defined_contribution_pension` to unknown' do
      expect(subject.has_defined_contribution_pension).to eq('unknown')
    end

    it 'does not validate presence of guider name' do
      subject.guider_name = ''

      subject.validate

      expect(subject.errors[:guider_name]).to be_empty
    end

    context 'when digital summary' do
      it 'only requires the postcode part of the address' do
        subject.requested_digital = true

        subject.address_line_1 = ''
        subject.address_line_2 = ''
        subject.address_line_3 = ''
        subject.town = ''
        subject.county = ''
        subject.postcode = 'RM1 1AA'

        expect(subject).to be_valid
      end
    end

    context 'when postal summary' do
      it 'requires the whole address' do
        subject.requested_digital = false

        subject.address_line_1 = ''

        expect(subject).to be_invalid
      end
    end
  end

  let(:has_defined_contribution_pension) { 'yes' }

  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to_not validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }

  it { is_expected.to validate_inclusion_of(:title).in_array(%w(Mr Mrs Miss Ms Mx Dr Reverend)) }
  it { is_expected.to_not allow_value('Alien').for(:title) }

  it { is_expected.to allow_value('2015-02-10').for(:date_of_appointment) }
  it { is_expected.to allow_value('12/02/2015').for(:date_of_appointment) }
  it { is_expected.to_not allow_value('10/02/2012').for(:date_of_appointment) }
  it { is_expected.to_not allow_value(Time.zone.tomorrow.to_s).for(:date_of_appointment) }

  it { is_expected.to validate_presence_of(:reference_number) }

  it { is_expected.to_not validate_presence_of(:value_of_pension_pots) }
  it { is_expected.to validate_numericality_of(:value_of_pension_pots) }
  it { is_expected.to allow_value('').for(:value_of_pension_pots) }

  it { is_expected.to_not validate_presence_of(:upper_value_of_pension_pots) }
  it { is_expected.to validate_numericality_of(:upper_value_of_pension_pots) }
  it { is_expected.to allow_value('').for(:upper_value_of_pension_pots) }
  it { is_expected.to validate_presence_of(:guider_name) }

  context 'when requesting postal' do
    before { subject.requested_digital = false }

    it { is_expected.to validate_presence_of(:address_line_1) }
    it { is_expected.to validate_length_of(:address_line_1).is_at_most(50) }
    it { is_expected.to_not validate_presence_of(:address_line_2) }
    it { is_expected.to validate_length_of(:address_line_2).is_at_most(50) }
    it { is_expected.to_not validate_presence_of(:address_line_3) }
    it { is_expected.to validate_length_of(:address_line_3).is_at_most(50) }
    it { is_expected.to validate_presence_of(:town) }
    it { is_expected.to validate_length_of(:town).is_at_most(50) }
    it { is_expected.to_not validate_presence_of(:county) }
    it { is_expected.to validate_length_of(:county).is_at_most(50) }
    it { is_expected.to validate_presence_of(:country) }
    it { is_expected.to validate_inclusion_of(:country).in_array(Countries.all) }
  end

  it { is_expected.to validate_presence_of(:postcode) }
  it { is_expected.to validate_inclusion_of(:number_of_previous_appointments).in_range(0..3) }

  shared_examples 'it is a valid email' do
    it { is_expected.to allow_value('fred.jones@pensionwise.gov.uk').for(:email) }
    it { is_expected.not_to allow_value('fred.jones').for(:email) }
    it { is_expected.not_to allow_value('fred@no-extension').for(:email) }
    it { is_expected.not_to allow_value('  fred@spaced.com  ').for(:email) }
    it { is_expected.not_to allow_value('a  fred@spaced.com').for(:email) }
    it { is_expected.not_to allow_value('a..fred@spaced.com').for(:email) }
    it { is_expected.not_to allow_value('fred@spaced..com').for(:email) }
    it { is_expected.to allow_value('a.fred@spaced.com').for(:email) }
    it { is_expected.not_to allow_value('fr@ed@spaced..com').for(:email) }
    it { is_expected.not_to allow_value('"fred"@spaced.com').for(:email) }
    it { is_expected.not_to allow_value('fred;jones@spaced.com').for(:email) }
  end

  context 'requested_digital is true' do
    before { subject.requested_digital = true }
    include_examples 'it is a valid email'

    it { is_expected.not_to allow_value('').for(:email) }
  end

  context 'requested_digital is false' do
    before { subject.requested_digital = false }
    include_examples 'it is a valid email'

    it { is_expected.to allow_value('').for(:email) }
  end

  describe '#country' do
    it "has a default value of #{Countries.uk}" do
      expect(subject.country).to eq(Countries.uk)
    end
  end

  describe 'postcode validation' do
    context 'for UK addresses' do
      before { subject.country = Countries.uk }

      it { is_expected.to validate_presence_of(:postcode) }
      it { is_expected.to allow_value('SW1A 2HQ').for(:postcode) }
      it { is_expected.to_not allow_value('nonsense').for(:postcode) }
    end

    context 'for non-UK addresses' do
      before { subject.country = Countries.non_uk.sample }

      it { is_expected.to_not validate_presence_of(:postcode) }
      it { is_expected.to allow_value('nonsense').for(:postcode) }
    end
  end

  it do
    is_expected
      .to validate_inclusion_of(:has_defined_contribution_pension)
      .in_array(%w(yes no unknown))
      .with_message('shoulda-matchers test string is not a valid value')
  end

  it do
    is_expected
      .to validate_inclusion_of(:appointment_type).in_array(%w(standard 50_54))
  end

  it 'defaults to a standard appointment type' do
    expect(subject.appointment_type).to eq('standard')
  end

  it do
    is_expected
      .to validate_inclusion_of(:format_preference).in_array(%w(standard large_text braille))
  end

  it 'has a defaults to a standard format preference' do
    expect(subject.format_preference).to eq('standard')
  end

  describe '#postcode=' do
    before { subject.postcode = ' sw1a 2hq    ' }

    specify { expect(subject.postcode).to eq('SW1A 2HQ') }
  end

  context 'when ineligible for guidance' do
    let(:has_defined_contribution_pension) { 'no' }

    it { is_expected.to_not be_eligible_for_guidance }

    it { is_expected.to_not validate_presence_of(:value_of_pension_pots) }
    it { is_expected.to_not validate_presence_of(:upper_value_of_pension_pots) }

    it { is_expected.to_not validate_numericality_of(:value_of_pension_pots) }
    it { is_expected.to_not validate_numericality_of(:upper_value_of_pension_pots) }

    it 'requires an answer to `has_defined_benefit_pension`' do
      expect(subject).to validate_inclusion_of(:has_defined_benefit_pension)
        .in_array(%w(yes no))
        .with_message('shoulda-matchers test string is not a valid value')
    end

    context 'when `has_defined_benefit_pension` is yes' do
      it 'requires an answer to `considering_transferring_to_dc_pot`' do
        subject.has_defined_benefit_pension = 'yes'

        expect(subject).to validate_inclusion_of(:considering_transferring_to_dc_pot)
          .in_array(%w(yes no))
          .with_message('shoulda-matchers test string is not a valid value')
      end
    end
  end

  context 'when eligible for guidance' do
    let(:has_defined_contribution_pension) { 'yes' }

    it { is_expected.to be_eligible_for_guidance }
  end

  describe '#braille_notification?' do
    it 'returns true when braille notification is needed' do
      summary = build_stubbed(:appointment_summary)

      expect(summary).not_to be_braille_notification

      summary.requested_digital = false
      summary.format_preference = 'braille'

      expect(summary).to be_braille_notification
    end
  end
end
