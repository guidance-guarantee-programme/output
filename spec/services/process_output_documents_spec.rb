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
    let(:batch) { instance_double(Batch) }
    let(:result) { 'result' }
    let(:upload_to_print_house) { instance_double(UploadToPrintHouse) }

    before do
      allow(UploadToPrintHouse).to receive(:new)
        .and_return(upload_to_print_house)

      allow(upload_to_print_house).to receive(:call)
        .with(batch).and_return(result)
    end

    it { is_expected.to eq(result) }
  end
end
