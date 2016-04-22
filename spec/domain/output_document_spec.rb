# frozen_string_literal: true
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
  let(:attendee_name) { "#{title} #{first_name} #{last_name}" }
  let(:value_of_pension_pots) { nil }
  let(:upper_value_of_pension_pots) { nil }
  let(:value_of_pension_pots_is_approximate) { false }
  let(:guider_name) { 'James' }
  let(:date_of_appointment) { Date.new(2015, 3, 9) }
  let(:appointment_date) { '9 March 2015' }
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
      country: country,
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

  describe '#variant' do
    let(:eligible_for_guidance) { true }

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

    it do
      is_expected.to eq(
        'You recently had a Pension Wise guidance appointment with James ' \
        "from The Pensions Advisory Service on #{appointment_date}."
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
end
