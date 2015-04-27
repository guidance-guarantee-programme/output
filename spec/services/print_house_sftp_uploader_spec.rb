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

  describe 'file uploads' do
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

  describe 'error handling and notifications' do
    let(:jobs_that_fail) { [jobs.first] }
    let(:jobs_that_succeed)  { jobs - jobs_that_fail }
    let(:failure_notifications) { [] }
    let(:success_notifications) { [] }

    before do
      jobs_that_fail.each do |job|
        allow(uploader).to receive(:upload_file)
          .with(job.payload_path, job.payload).and_raise('upload failed!')
      end

      uploader.on(:upload_failed) { |*args| failure_notifications << args }
      uploader.on(:upload_succeeded) { |*args| success_notifications << args }
    end

    subject! { uploader.call(jobs) }

    it 'notifies subscribers for each successful upload' do
      expect(success_notifications.count).to eq(jobs_that_succeed.count)
    end

    it 'includes the job in success notifications' do
      successful_jobs = success_notifications.map { |args| args[0] }

      expect(successful_jobs).to eq(jobs_that_succeed)
    end

    it 'notifies subscribers for each failed upload' do
      expect(failure_notifications.count).to eq(jobs_that_fail.count)
    end

    it 'includes the job in failure notifications' do
      failed_jobs = failure_notifications.map { |args| args[0] }

      expect(failed_jobs).to eq(jobs_that_fail)
    end

    it 'includes the exception in failure notifications' do
      exceptions = failure_notifications.map { |args| args[1] }

      expect(exceptions).to all(be_a(StandardError))
    end
  end
end
