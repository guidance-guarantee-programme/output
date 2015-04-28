require 'rails_helper'

RSpec.describe ProcessOutputDocuments, '#call' do
  let(:batch) { instance_double(Batch).as_null_object }
  let(:job) { instance_double(CSVUploadJob, batch: batch).as_null_object }
  let(:create_batch) { instance_double(CreateBatch, call: batch).as_null_object }
  let(:upload_to_print_house) { instance_double(UploadToPrintHouse).as_null_object }

  before do
    allow(CreateBatch).to receive(:new).and_return(create_batch)
    allow(CSVUploadJob).to receive(:new).with(batch).and_return(job)
    allow(UploadToPrintHouse).to receive(:new).with(job).and_return(upload_to_print_house)

    described_class.new.call
  end

  describe 'creates a new batch' do
    subject { create_batch }

    it { is_expected.to have_received(:call) }
  end

  describe 'uploads the created batch to the print house' do
    subject { upload_to_print_house }

    it { is_expected.to have_received(:call) }
  end

  describe 'marks the batch as uploaded' do
    subject { batch }

    it { is_expected.to have_received(:mark_as_uploaded) }
  end

  context 'when no items for processing' do
    let(:batch) { nil }

    subject { upload_to_print_house }

    it { is_expected.not_to have_received(:call) }
  end
end
