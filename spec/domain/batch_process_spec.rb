require 'rails_helper'

RSpec.describe BatchProcess do
  let(:headers) { OutputDocument::CSVRenderer::FIELDS.join('|') }
  let(:csv) { 'csv' }
  let(:output_document) { double(csv: csv) }

  describe '#csv' do
    subject(:lines) { described_class.new([output_document]).csv.split("\n") }

    specify { expect(lines.first).to eq(headers) }
    specify { expect(lines.last).to eq(csv) }
  end
end
