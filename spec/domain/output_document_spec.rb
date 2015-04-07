require 'rails_helper'

RSpec.describe OutputDocument do
  let(:title) { 'Mr' }
  let(:first_name) { 'Joe' }
  let(:last_name) { 'Bloggs' }
  let(:address_line_1) { 'HM Treasury' }
  let(:address_line_2) { '1 Horse Guards Road' }
  let(:address_line_3) { 'Whitehall' }
  let(:town) { 'London' }
  let(:county) { '' }
  let(:postcode) { 'SW1A 2HQ' }
  let(:attendee_name) { "#{title} #{first_name} #{last_name}" }
  let(:value_of_pension_pots) { nil }
  let(:upper_value_of_pension_pots) { nil }
  let(:value_of_pension_pots_is_approximate) { false }
  let(:guider_name) { 'James' }
  let(:date_of_appointment) { Date.new(2015, 3, 30) }
  let(:guider_organisation) { 'tpas' }
  let(:reference_number) { '123456789' }
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
      postcode: postcode,
      date_of_appointment: date_of_appointment,
      reference_number: reference_number,
      value_of_pension_pots: value_of_pension_pots,
      upper_value_of_pension_pots: upper_value_of_pension_pots,
      value_of_pension_pots_is_approximate: value_of_pension_pots_is_approximate,
      income_in_retirement: :pension,
      guider_name: guider_name,
      guider_organisation: guider_organisation
    }
  end
  let(:appointment_summary) { AppointmentSummary.new(params) }

  subject(:output_document) { described_class.new(appointment_summary) }

  specify { expect(output_document.attendee_name).to eq(attendee_name) }

  describe '#attendee_address' do
    subject { output_document.attendee_address }

    let(:title) { 'Mr' }
    let(:first_name) { 'Joe' }
    let(:last_name) { 'Bloggs' }
    let(:address_line_1) { 'HM Treasury' }
    let(:address_line_2) { '1 Horse Guards Road' }
    let(:address_line_3) { 'Whitehall' }
    let(:town) { 'London' }
    let(:county) { '' }
    let(:postcode) { 'SW1A 2HQ' }

    context 'when lines are blank' do
      let(:address_line_3) { '' }

      it { is_expected.to eq("Mr Joe Bloggs\nHM Treasury\n1 Horse Guards Road\nLondon\nSW1A 2HQ") }
    end

    context 'when lines contain leading or tailing whitespace' do
      let(:address_line_2) { '1 Horse Guards Road            ' }
      let(:address_line_3) { '' }
      let(:town) { '               London' }
      let(:postcode) { 'SW1A                         2HQ' }

      it { is_expected.to eq("Mr Joe Bloggs\nHM Treasury\n1 Horse Guards Road\nLondon\nSW1A 2HQ") }
    end
  end

  describe '#guider_organisation' do
    subject { output_document.guider_organisation }

    context 'when TPAS' do
      it { is_expected.to eq('The Pensions Advisory Service') }
    end

    context 'when PensionWise' do
      let(:guider_organisation) { 'pw' }

      it { is_expected.to eq('Pension Wise') }
    end
  end

  describe '#value_of_pension_pots' do
    subject { output_document.value_of_pension_pots }

    context 'with one pension pot value' do
      let(:value_of_pension_pots) { 35_000 }
      let(:upper_value_of_pension_pots) { nil }

      it { is_expected.to eq('£35,000') }

      context 'and it is approximate' do
        let(:value_of_pension_pots_is_approximate) { true }

        it { is_expected.to eq('£35,000 (approximately)') }
      end
    end

    context 'with two pension pot values' do
      let(:value_of_pension_pots) { 35_000 }
      let(:upper_value_of_pension_pots) { 55_000 }

      it { is_expected.to eq('£35,000 to £55,000') }
    end

    context 'with no pension pot values' do
      let(:value_of_pension_pots) { nil }
      let(:upper_value_of_pension_pots) { nil }

      it { is_expected.to eq('No value given') }
    end
  end

  describe '#variant' do
    let(:eligible_for_guidance) { true }
    let(:generic_guidance) { true }
    let(:custom_guidance) { true }

    before do
      allow(appointment_summary).to receive_messages(
        eligible_for_guidance?: eligible_for_guidance,
        generic_guidance?: generic_guidance,
        custom_guidance?: custom_guidance
      )
    end

    subject { output_document.variant }

    context 'when ineligible for guidance' do
      let(:eligible_for_guidance) { false }

      it { is_expected.to eq('other') }
    end

    context 'when eligible for guidance' do
      context 'and generic guidance was given' do
        let(:custom_guidance) { false }

        it { is_expected.to eq('generic') }
      end

      context 'and custom guidance was given' do
        let(:generic_guidance) { false }

        it { is_expected.to eq('tailored') }
      end
    end
  end

  describe '#lead' do
    subject { output_document.lead }

    it do
      is_expected.to eq(
        'You recently had a Pension Wise guidance appointment with James ' \
        'from The Pensions Advisory Service on 30 March 2015.'
      )
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

  describe '#html' do
    let(:html) { 'html' }
    let(:renderer) { double(render: html) }

    subject { output_document.html }

    before do
      allow(OutputDocument::HTMLRenderer).to receive(:new)
        .with(output_document)
        .and_return(renderer)
    end

    it { is_expected.to eq(html) }
  end

  describe '#csv' do
    let(:csv) { 'csv' }
    let(:renderer) { double(render: csv) }

    subject { output_document.csv }

    before do
      allow(OutputDocument::CSVRenderer).to receive(:new)
        .with(output_document)
        .and_return(renderer)
    end

    it { is_expected.to eq(csv) }
  end
end
