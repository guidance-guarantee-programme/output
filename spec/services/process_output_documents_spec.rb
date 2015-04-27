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
    let(:csv_upload_job) { instance_double(CSVUploadJob) }
    let(:result) { 'result' }
    let(:print_house) { instance_double(PrintHouseSFTPUploader, call: result) }

    before do
      allow(CSVUploadJob).to receive(:new)
        .with(batch).and_return(csv_upload_job)

      allow(PrintHouseSFTPUploader).to receive(:new)
        .and_return(print_house)

      allow(print_house).to receive(:call)
        .with(csv_upload_job).and_return(result)
    end

    it { is_expected.to eq(result) }
  end
end
