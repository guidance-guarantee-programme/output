require 'rails_helper'

RSpec.describe PrintHouseSFTPUploader, '#call' do
  let(:jobs) do
    3.times.map do |n|
      instance_double(CSVUploadJob, payload: "payload #{n}",
                                    payload_path: "/payload_path/#{n}.payload",
                                    trigger: "trigger #{n}",
                                    trigger_path: "/trigger_path/#{n}.trigger")
    end
  end

  let(:uploader) { described_class.new }
  before { allow(uploader).to receive(:upload_file) }

  subject! { uploader.call(jobs) }

  it 'uploads data from all specified jobs' do
    jobs.each do |job|
      expect(uploader).to have_received(:upload_file).with(job.payload_path, job.payload)
      expect(uploader).to have_received(:upload_file).with(job.trigger_path, job.trigger)
    end
  end

  it 'uploads trigger files after their respective payloads' do
    jobs.each do |job|
      expect(uploader).to have_received(:upload_file).with(job.payload_path, job.payload).ordered
      expect(uploader).to have_received(:upload_file).with(job.trigger_path, job.trigger).ordered
    end
  end
end
