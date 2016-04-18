# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ProcessOutputDocuments, '#call' do
  let(:batches) { Array.new(3) { instance_double(Batch).as_null_object } }
  let(:jobs) { Array(batches).map { instance_double(CSVUploadJob).as_null_object } }
  let(:uploaders) { Array(batches).map { instance_double(UploadToPrintHouse).as_null_object } }
  let(:create_batch) { instance_double(CreateBatch).as_null_object }

  before do
    allow(CreateBatch).to receive(:new).and_return(create_batch)
    allow(Batch).to receive(:unprocessed).and_return(batches)
    Array(batches).count.times do |n|
      batch = batches[n]
      job = jobs[n]
      uploader = uploaders[n]
      allow(CSVUploadJob).to receive(:new).with(batch).and_return(job)
      allow(UploadToPrintHouse).to receive(:new).with(job).and_return(uploader)
    end

    described_class.new.call
  end

  describe 'creates a new batch' do
    subject { create_batch }

    it { is_expected.to have_received(:call) }
  end

  describe 'uploads all unprocessed batches to the print house' do
    subject { uploaders }

    it { is_expected.to all(have_received(:call)) }
  end

  describe 'marks each batch as uploaded' do
    subject { batches }

    it { is_expected.to all(have_received(:mark_as_uploaded)) }
  end

  context 'when no items for processing' do
    [[], nil].each do |no_items|
      let(:batches) { no_items }

      it 'uploads nothing' do
        uploaders.each { |uploader| expect(uploader).not_to have_received(:call) }
      end
    end
  end
end
