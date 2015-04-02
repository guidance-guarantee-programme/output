require 'rails_helper'

RSpec.describe OutputDocument::HTMLRenderer do
  let(:variant) { 'tailored' }
  let(:attributes) do
    {
      id: '',
      format: '',
      variant: variant,
      attendee_name: '',
      attendee_address_line_1: '',
      attendee_address_line_2: '',
      attendee_address_line_3: '',
      attendee_town: '',
      attendee_county: '',
      attendee_postcode: '',
      lead: '',
      guider_first_name: '',
      guider_organisation: '',
      appointment_reference: '',
      appointment_date: '',
      value_of_pension_pots: '',
      income_in_retirement: '',
      continue_working: false,
      unsure: false,
      leave_inheritance: false,
      wants_flexibility: false,
      wants_security: false,
      wants_lump_sum: false,
      poor_health: false
    }
  end
  let(:output_document) { instance_double(OutputDocument, attributes) }

  subject(:html_renderer) { described_class.new(output_document) }

  describe '#pages_to_render' do
    subject { html_renderer.pages_to_render }

    context 'with "tailored" variant' do
      %i(continue_working unsure leave_inheritance wants_flexibility wants_security
         wants_lump_sum poor_health).each do |circumstance|
        context "for '#{circumstance}'" do
          before do
            attributes[circumstance] = true
          end

          it { is_expected.to eq([:cover_letter, :introduction, circumstance, :other_information]) }
        end
      end
    end

    context 'with "generic" variant' do
      let(:variant) { 'generic' }

      it { is_expected.to eq(%w(cover_letter introduction generic_guidance other_information)) }
    end

    context 'with "other" variant' do
      let(:variant) { 'other' }

      it { is_expected.to eq(%w(ineligible)) }
    end
  end

  describe '#render' do
    let(:cover_letter_text) { 't-cover-letter' }
    let(:ineligible_text) { 't-ineligible' }
    let(:generic_guidance_text) { 't-generic' }
    let(:continue_working_text) { 't-continue-working' }
    let(:unsure_text) { 't-unsure' }
    let(:leave_inheritance_text) { 't-leave-inheritance' }
    let(:wants_flexibility_text) { 't-wants-flexibility' }
    let(:wants_security_text) { 't-wants-security' }
    let(:wants_lump_sum_text) { 't-wants-lump-sum' }
    let(:poor_health_text) { 't-poor-health' }

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

    subject { html_renderer.render }

    context 'when ineligible for guidance' do
      let(:variant) { 'other' }

      it { is_expected.to include(ineligible_text) }
      it { is_expected.to_not include(generic_guidance_text) }
      it { is_expected.to_not include(cover_letter_text) }
      it { excludes_all_circumstances }
    end

    context 'when eligible for guidance' do
      context 'and generic guidance was given' do
        let(:variant) { 'generic' }

        it { is_expected.to include(generic_guidance_text) }
        it { is_expected.to_not include(ineligible_text) }
        it { is_expected.to include(cover_letter_text) }
        it { excludes_all_circumstances }
      end

      context 'and custom guidance was given' do
        let(:variant) { 'tailored' }

        %i(continue_working unsure leave_inheritance wants_flexibility wants_security
           wants_lump_sum poor_health).each do |circumstance|
          context "for '#{circumstance}'" do
            before do
              attributes[circumstance] = true
            end

            it { is_expected.to_not include(generic_guidance_text) }
            it { is_expected.to_not include(ineligible_text) }
            it { is_expected.to include(cover_letter_text) }
            it { only_includes_circumstance(circumstance) }
          end
        end
      end
    end
  end
end
