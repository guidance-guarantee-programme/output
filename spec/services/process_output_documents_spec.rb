require 'rails_helper'

RSpec.describe ProcessOutputDocuments, '#call' do
  let(:create_batch) { instance_double(CreateBatch).as_null_object }
  let(:upload_to_print_house) { instance_double(UploadToPrintHouse).as_null_object }
  let(:service)  { described_class.new }

  before do
    allow(CreateBatch).to receive(:new).and_return(create_batch)
    allow(UploadToPrintHouse).to receive(:new).and_return(upload_to_print_house)
  end

  describe 'creates a new batch' do
    before { service.call }

    subject { create_batch }

    it { is_expected.to have_received(:call) }
  end

  describe 'uploads the created batch to the print house' do
    let(:batch) { instance_double(Batch) }

    before do
      allow(create_batch).to receive(:call).and_return(batch)
      service.call
    end

    subject { upload_to_print_house }

    it { is_expected.to have_received(:call).with(batch) }
  end

  describe 'does nothing when there are no unprocessed batches' do
    before do
      allow(create_batch).to receive(:call).and_return(nil)
      service.call
    end

    subject { upload_to_print_house }

    it { is_expected.not_to have_received(:call) }
  end
end
