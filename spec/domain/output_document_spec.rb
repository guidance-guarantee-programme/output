require 'rails_helper'

RSpec.describe OutputDocument do
  let(:title) { 'Mr' }
  let(:first_name) { 'Joe' }
  let(:last_name) { 'Bloggs' }
  let(:address_line_1) { 'HM Treasury' }
  let(:address_line_2) { '1 Horse Guards Road' }
  let(:address_line_3) { 'Whitehall' }
  let(:town) { 'Westminster' }
  let(:county) { 'Greater London' }
  let(:country) { 'United Kingdom' }
  let(:postcode) { 'SW1A 2HQ' }
  let(:attendee_name) { "#{title} #{last_name}" }
  let(:value_of_pension_pots) { nil }
  let(:upper_value_of_pension_pots) { nil }
  let(:value_of_pension_pots_is_approximate) { false }
  let(:guider_name) { 'James' }
  let(:date_of_appointment) { Date.new(2015, 3, 9) }
  let(:appointment_date) { '9 March 2015' }
  let(:reference_number) { '123456789' }
  let(:welsh) { false }
  let(:params) do
    {
      title: title,
      first_name: first_name,
      last_name: last_name,
      address_line_1: address_line_1,
      address_line_2: address_line_2,
      address_line_3: address_line_3,
      town: town,
      county: county,
      country: country,
      postcode: postcode,
      date_of_appointment: date_of_appointment,
      reference_number: reference_number,
      value_of_pension_pots: value_of_pension_pots,
      upper_value_of_pension_pots: upper_value_of_pension_pots,
      value_of_pension_pots_is_approximate: value_of_pension_pots_is_approximate,
      guider_name: guider_name,
      welsh: welsh
    }
  end
  let(:appointment_summary) { AppointmentSummary.new(params) }

  subject(:output_document) { described_class.new(appointment_summary) }

  specify { expect(output_document.attendee_name).to eq(attendee_name) }
  specify { expect(output_document.welsh?).to eq(false) }
  specify { expect(output_document.appointment_date).to eq(appointment_date) }

  describe '#attendee_country' do
    subject(:attendee_country) { output_document.attendee_country }

    context 'when United Kingdom' do
      let(:country) { Countries.uk }

      it 'is nil' do
        expect(attendee_country).to be_nil
      end
    end

    context 'with a non-UK address' do
      let(:country) { Countries.non_uk.sample }

      it 'includes the Country in uppercase' do
        expect(attendee_country).to eq(country.upcase)
      end
    end
  end

  describe '#attendee_address' do
    subject(:attendee_address) { output_document.attendee_address }

    context 'with a UK address' do
      let(:country) { Countries.uk }

      it 'does not include the Country' do
        expect(attendee_address).to eq("Mr Joe Bloggs\nHM Treasury\n1 Horse Guards Road\nWhitehall\n" \
                                       "Westminster\nGreater London\nSW1A 2HQ")
      end
    end

    context 'with a non-UK address' do
      let(:country) { Countries.non_uk.sample }

      it 'includes the Country in uppercase' do
        expect(attendee_address).to end_with(country.upcase)
      end
    end

    context 'when optional lines are blank' do
      let(:county) { '' }
      let(:address_line_3) { '' }

      it do
        is_expected.to eq("Mr Joe Bloggs\nHM Treasury\n1 Horse Guards Road\n" \
                          "Westminster\nSW1A 2HQ")
      end
    end

    context 'when lines contain redundant whitespace' do
      let(:address_line_1) { '    HM     Treasury' }
      let(:address_line_2) { '  1 Horse   Guards Road            ' }
      let(:address_line_3) { '  Whitehall  ' }
      let(:town) { '               Westminster  ' }
      let(:county) { '    Greater     London    ' }
      let(:postcode) { '  SW1A                         2HQ  ' }

      it do
        is_expected.to eq("Mr Joe Bloggs\nHM Treasury\n1 Horse Guards Road\nWhitehall\n" \
                          "Westminster\nGreater London\nSW1A 2HQ")
      end
    end
  end

  describe '#variant' do
    let(:eligible_for_guidance) { true }

    context 'when due diligence' do
      it 'is the due diligence variant' do
        allow(appointment_summary).to receive(:schedule_type).and_return('due_diligence')

        expect(subject).to eq('due_diligence')
      end
    end

    before do
      allow(appointment_summary).to receive_messages(
        eligible_for_guidance?: eligible_for_guidance
      )
    end

    subject { output_document.variant }

    context 'when ineligible for guidance' do
      let(:eligible_for_guidance) { false }

      it { is_expected.to eq('other') }
    end

    context 'when eligible for guidance' do
      it { is_expected.to eq('standard') }
    end
  end

  describe '#lead' do
    subject { output_document.lead }

    context 'when English' do
      it do
        is_expected.to eq(
          "You recently had a Pension Wise guidance appointment with James on #{appointment_date}."
        )
      end
    end

    context 'when Welsh' do
      let(:welsh) { true }

      it do
        is_expected.to eq(
          'Yn ddiweddar, cawsoch apwyntiad arweiniad Pension Wise gyda James ar 9 Mawrth 2015.'
        )
      end
    end
  end

  describe '#appointment_reference' do
    let(:id) { 'internal-id' }

    before do
      allow(appointment_summary).to receive(:id).and_return(id)
    end

    it 'provides a unique reference even for duplicate `reference_number`s' do
      expect(output_document.appointment_reference).to eq("#{id}/#{reference_number}")
    end
  end

  describe 'additional next steps' do
    context 'when no answer was given' do
      %i[
        updated_beneficiaries?
        regulated_financial_advice?
        kept_track_of_all_pensions?
        interested_in_pension_transfer?
        created_retirement_budget?
        know_how_much_state_pension?
        received_state_benefits?
        pension_to_pay_off_debts?
        living_or_planning_overseas?
        finalised_a_will?
        setup_power_of_attorney?
      ].each do |predicate|
        it "#{predicate} is false" do
          expect(output_document.public_send(predicate)).to be false
        end
      end

      it '#next_steps? is false' do
        expect(output_document).not_to be_next_steps
      end
    end

    context 'when positive answers were given' do
      before do
        appointment_summary.updated_beneficiaries = 'no'
        appointment_summary.regulated_financial_advice = 'yes'
        appointment_summary.kept_track_of_all_pensions = 'no'
        appointment_summary.interested_in_pension_transfer = 'yes'
        appointment_summary.created_retirement_budget = 'no'
        appointment_summary.know_how_much_state_pension = 'no'
        appointment_summary.received_state_benefits = 'yes'
        appointment_summary.pension_to_pay_off_debts = 'yes'
        appointment_summary.living_or_planning_overseas = 'yes'
        appointment_summary.finalised_a_will = 'no'
        appointment_summary.setup_power_of_attorney = 'no'
      end

      %i[
        updated_beneficiaries?
        regulated_financial_advice?
        kept_track_of_all_pensions?
        interested_in_pension_transfer?
        created_retirement_budget?
        know_how_much_state_pension?
        received_state_benefits?
        pension_to_pay_off_debts?
        living_or_planning_overseas?
        finalised_a_will?
        setup_power_of_attorney?
      ].each do |predicate|
        it "#{predicate} is true" do
          expect(output_document.public_send(predicate)).to be true
        end

        it '#next_steps? is true' do
          expect(output_document).to be_next_steps
        end
      end
    end
  end

  describe '#html' do
    let(:html) { 'html' }
    let(:renderer) { double(render: html) }

    subject { output_document.html }

    before do
      allow(OutputDocument::HtmlRenderer).to receive(:new)
        .with(output_document)
        .and_return(renderer)
    end

    it { is_expected.to eq(html) }
  end
end
