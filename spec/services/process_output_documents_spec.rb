require 'rails_helper'

RSpec.describe ProcessOutputDocuments, '#call' do
  let(:create_batch) { instance_double(CreateBatch).as_null_object }
  let(:upload_to_print_house) { instance_double(UploadToPrintHouse).as_null_object }
  let(:service)  { described_class.new }

  before do
    allow(CreateBatch).to receive(:new).and_return(create_batch)
    allow(UploadToPrintHouse).to receive(:new).and_return(upload_to_print_house)
    allow(Batch).to receive(:unprocessed)
  end

  describe 'creates a new batch' do
    before { service.call }

    subject { create_batch }

    it { is_expected.to have_received(:call) }
  end

  describe 'uploads all unprocessed batches to the print house' do
    let(:unprocessed_batches) { 3.times.map { instance_double(Batch) } }

    before do
      allow(Batch).to receive(:unprocessed).and_return(unprocessed_batches)
      service.call
    end

    subject { upload_to_print_house }

    it { is_expected.to have_received(:call).with(unprocessed_batches) }
  end
end
