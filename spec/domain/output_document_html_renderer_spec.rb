require 'rails_helper'

RSpec.describe OutputDocument::HTMLRenderer do
  let(:templates_dir) { Rails.root.join('spec', 'fixtures', 'templates') }
  let(:variant) { 'tailored' }
  let(:attributes) do
    {
      variant: variant,
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

  subject(:html_renderer) { described_class.new(output_document, templates_dir) }

  describe '#pages_to_render' do
    subject { html_renderer.pages_to_render }

    context 'with "tailored" variant' do
      %i(continue_working unsure leave_inheritance wants_flexibility wants_security
         wants_lump_sum poor_health).each do |circumstance|
        context "for circumstance '#{circumstance}'" do
          before { attributes[circumstance] = true }

          %i(pension other).each do |source_of_income|
            context "and income in retirement: '#{source_of_income}'" do
              before { attributes[:income_in_retirement] = source_of_income }

              it do
                is_expected.to eq([:covering_letter, :introduction, :"pension_pot_#{source_of_income}",
                                   :options_overview, circumstance, :other_information])
              end
            end
          end
        end
      end
    end

    context 'with "generic" variant' do
      let(:variant) { 'generic' }

      %i(pension other).each do |source_of_income|
        context "and income in retirement: '#{source_of_income}'" do
          before { attributes[:income_in_retirement] = source_of_income }

          it do
            is_expected.to eq([:covering_letter, :introduction, :"pension_pot_#{source_of_income}", :options_overview,
                               :generic_guidance, :other_information])
          end
        end
      end
    end

    context 'with "other" variant' do
      let(:variant) { 'other' }

      it { is_expected.to eq([:ineligible]) }
    end
  end

  describe '#render' do
    before do
      allow(html_renderer).to receive(:pages_to_render).and_return([:content])
    end

    subject { html_renderer.render }

    it { is_expected.to match(/header.*content.*footer/m) }
  end
end
