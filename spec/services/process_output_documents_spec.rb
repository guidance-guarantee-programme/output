require 'rails_helper'

RSpec.describe ProcessOutputDocuments, '#call' do
  let(:batch) { nil }

  subject { described_class.new.call }

  before do
    allow(CreateBatch)
      .to receive(:new)
      .and_return(-> { batch })
  end

  context 'with no items for processing' do
    it { is_expected.to be_nil }
  end

  context 'with items for processing' do
    let(:appointment_summary) { instance_double(AppointmentSummary) }
    let(:batch) { instance_double(Batch, appointment_summaries: [appointment_summary]) }
    let(:output_document) { instance_double(OutputDocument) }
    let(:csv) { 'c,s,v' }
    let(:csv_renderer) { instance_double(CSVRenderer, render: csv) }
    let(:result) { 'result' }
    let(:print_house) { instance_double(UploadToPrintHouse, call: result) }

    before do
      allow(OutputDocument).to receive(:new)
        .with(appointment_summary).and_return(output_document)
      allow(CSVRenderer).to receive(:new)
        .with([output_document]).and_return(csv_renderer)
      allow(UploadToPrintHouse).to receive(:new)
        .with(csv).and_return(print_house)
    end

    it { is_expected.to eq(result) }
  end
end
