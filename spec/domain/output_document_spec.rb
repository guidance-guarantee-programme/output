require 'rails_helper'

RSpec.describe OutputDocument do
  let(:title) { 'Mr' }
  let(:first_name) { 'Joe' }
  let(:last_name) { 'Bloggs' }
  let(:attendee_name) { "#{title} #{first_name} #{last_name}" }
  let(:value_of_pension_pots) { nil }
  let(:upper_value_of_pension_pots) { nil }
  let(:guider_organisation) { 'tpas' }
  let(:params) do
    {
      title: title,
      first_name: first_name,
      last_name: last_name,
      date_of_appointment: Date.today,
      value_of_pension_pots: value_of_pension_pots,
      upper_value_of_pension_pots: upper_value_of_pension_pots,
      income_in_retirement: :pension,
      guider_name: 'A Guider',
      guider_organisation: guider_organisation
    }
  end
  let(:appointment_summary) { AppointmentSummary.new(params) }
  let(:ineligible_text) { 't-ineligible' }
  let(:generic_guidance_text) { 't-generic' }
  let(:continue_working_text) { 't-continue-working' }
  let(:unsure_text) { 't-unsure' }
  let(:leave_inheritance_text) { 't-leave-inheritance' }
  let(:wants_flexibility_text) { 't-wants-flexibility' }
  let(:wants_security_text) { 't-wants-security' }
  let(:wants_lump_sum_text) { 't-wants-lump-sum' }
  let(:poor_health_text) { 't-poor-health' }

  subject(:output_document) { described_class.new(appointment_summary) }

  def only_includes_circumstance(circumstance)
    circumstances = %i(continue_working unsure leave_inheritance
                       wants_flexibility wants_security
                       wants_lump_sum poor_health)

    unless circumstance.empty?
      expect(subject).to include(send("#{circumstance}_text"))
    end

    (circumstances - [circumstance]).each do |non_applicable_circumstance|
      expect(subject).to_not include(send("#{non_applicable_circumstance}_text"))
    end
  end

  def excludes_all_circumstances
    only_includes_circumstance('')
  end

  specify { expect(output_document.attendee_name).to eq(attendee_name) }

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

  describe '#html' do
    subject { output_document.html }

    it { is_expected.to include(attendee_name) }

    context 'when ineligible for guidance' do
      before do
        allow(appointment_summary).to receive(:eligible_for_guidance?).and_return(false)
      end

      it { is_expected.to include(ineligible_text) }
      it { is_expected.to_not include(generic_guidance_text) }
      it { excludes_all_circumstances }
    end

    context 'when eligible for guidance' do
      before do
        allow(appointment_summary).to receive(:eligible_for_guidance?).and_return(true)
      end

      context 'and generic guidance was given' do
        it { is_expected.to include(generic_guidance_text) }
        it { is_expected.to_not include(ineligible_text) }
        it { excludes_all_circumstances }
      end

      context 'and custom guidance was given' do
        %i(continue_working unsure leave_inheritance wants_flexibility wants_security
           wants_lump_sum poor_health).each do |circumstance|
          context "for '#{circumstance}'" do
            before do
              allow(appointment_summary).to receive("#{circumstance}?".to_sym).and_return(true)
            end

            it { is_expected.to_not include(generic_guidance_text) }
            it { is_expected.to_not include(ineligible_text) }
            it { only_includes_circumstance(circumstance) }
          end
        end
      end
    end
  end

  describe '#csv' do
    subject { output_document.csv }

    it { is_expected.to_not be_empty }
  end
end
