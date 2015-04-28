require 'rails_helper'
require 'wisper/rspec/stub_wisper_publisher'

RSpec.describe UploadToPrintHouse, '#call' do
  let(:batch_one) { instance_double(Batch).as_null_object }
  let(:batch_two) { instance_double(Batch).as_null_object }
  let(:batch_three) { instance_double(Batch).as_null_object }
  let(:job_one) { instance_double(CSVUploadJob, batch: batch_one).as_null_object }
  let(:job_two) { instance_double(CSVUploadJob, batch: batch_two).as_null_object }
  let(:job_three) { instance_double(CSVUploadJob, batch: batch_three).as_null_object }
  let(:print_house_sftp_uploader) { instance_double(PrintHouseSFTPUploader).as_null_object }
  let(:upload_to_print_house) { described_class.new }

  before do
    allow(CSVUploadJob).to receive(:new).with(batch_one).and_return(job_one)
    allow(CSVUploadJob).to receive(:new).with(batch_two).and_return(job_two)
    allow(CSVUploadJob).to receive(:new).with(batch_three).and_return(job_three)
    allow(PrintHouseSFTPUploader).to receive(:new).and_return(print_house_sftp_uploader)
  end

  describe 'uploads the specified batches to the print house' do
    before { upload_to_print_house.call([batch_one, batch_two, batch_three]) }

    subject { print_house_sftp_uploader }

    it { is_expected.to have_received(:call).with([job_one, job_two, job_three]) }
  end

  describe 'records the upload date for succesfully uploaded batches' do
    before do
      stub_wisper_publisher('PrintHouseSFTPUploader',
                            :call,
                            :upload_success,
                            job_one)

      upload_to_print_house.call(batch_one)
    end

    subject { batch_one }

    it { is_expected.to have_received(:mark_as_uploaded) }
  end

  describe 'does not record the upload date for failed batches' do
    before do
      stub_wisper_publisher('PrintHouseSFTPUploader',
                            :call,
                            :upload_failure,
                            job_one,
                            RuntimeError.new('Upload failed!'))

      upload_to_print_house.call(batch_one)
    end

    subject { batch_one }

    it { is_expected.not_to have_received(:mark_as_uploaded) }
  end

  [nil, []].each do |no_batches|
    context "with #{no_batches.inspect} batches" do
      before { upload_to_print_house.call(no_batches) }

      subject { print_house_sftp_uploader }

      it { is_expected.not_to have_received(:call) }
    end
  end
end
