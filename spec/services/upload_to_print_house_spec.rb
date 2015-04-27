require 'rails_helper'

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
end
