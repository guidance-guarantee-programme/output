require 'rails_helper'

RSpec.describe PdfDownloadUrlPresenter, '#call' do
  let(:config) { double(pdf_download_host: 'https://example.com') }

  context 'when appointment is standard, English' do
    it 'specifies the correct file URL' do
      appointment = double(
        eligible_for_guidance?: true,
        standard?: true,
        supplementary_defined_benefit_pensions: false,
        welsh?: false
      )

      expect(described_class.new(appointment, config).call).to eq('https://example.com/standard.pdf')
    end
  end

  context 'when appointment is non-standard, DB, English' do
    it 'specifies the correct file URL' do
      appointment = double(
        eligible_for_guidance?: true,
        standard?: false,
        supplementary_defined_benefit_pensions: true,
        welsh?: false
      )

      expect(described_class.new(appointment, config).call).to eq('https://example.com/non-standard-db.pdf')
    end
  end

  context 'when appointment is non-standard, DB, Welsh' do
    it 'specifies the correct file URL' do
      appointment = double(
        eligible_for_guidance?: true,
        standard?: false,
        supplementary_defined_benefit_pensions: true,
        welsh?: true
      )

      expect(described_class.new(appointment, config).call).to eq('https://example.com/non-standard-db-cy.pdf')
    end
  end
end
