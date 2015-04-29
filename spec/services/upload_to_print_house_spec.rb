require 'rails_helper'
require 'net/sftp'

RSpec.describe UploadToPrintHouse, '#call' do
  class FakeSFTP
    attr_reader :uploaded

    def initialize
      @uploaded = []
    end

    def upload!(io, path)
      uploaded << { contents: io.read, path: path }
    end
  end

  let(:sftp) { FakeSFTP.new }
  let(:csv) { 'c,s,v' }
  let(:csv_path) { '/Data.in/pensionwise_output_20150103050204000.csv' }
  let(:trigger) { '' }
  let(:trigger_path) { '/Data.in/pensionwise_output_20150103050204000.trg' }
  let(:csv_upload_job) do
    instance_double(CSVUploadJob, payload: csv,
                                  payload_path: csv_path,
                                  trigger: trigger,
                                  trigger_path: trigger_path)
  end

  subject(:uploader) { described_class.new(csv_upload_job) }

  before { allow(Net::SFTP).to receive(:start).and_yield(sftp) }

  context 'when no errors occur during upload' do
    before { uploader.call }

    it 'uploads the CSV' do
      expect(sftp.uploaded).to include(contents: csv, path: csv_path)
    end

    it 'uploads the trigger file' do
      expect(sftp.uploaded).to include(contents: trigger, path: trigger_path)
    end

    it 'uploads the trigger file after the CSV' do
      ordered_uploaded_paths = sftp.uploaded.map { |upload| upload [:path] }
      expect(ordered_uploaded_paths).to eq([csv_path, trigger_path])
    end
  end

  context 'when errors occur during upload' do
    class ErroringFakeSFTP < FakeSFTP
      ERROR_MESSAGE = 'SFTP error!'

      def initialize(errors_to_raise)
        super()
        @errors_to_raise = errors_to_raise
        @error_count = 0
      end

      def upload!(*args)
        fail ERROR_MESSAGE unless (@error_count += 1) > @errors_to_raise
        super
      end
    end

    let(:sftp) { ErroringFakeSFTP.new(errors_to_raise) }

    context 'when up to 5 errors occur' do
      let(:errors_to_raise) { 5 }

      before { uploader.call }

      it 'retries until the upload succeeds' do
        expect(sftp.uploaded).to eq([{ contents: csv, path: csv_path }, { contents: trigger, path: trigger_path }])
      end
    end

    context 'when more than 5 errors occur' do
      let(:errors_to_raise) { 6 }

      it 'stops retrying' do
        expect { uploader.call }.to raise_error(ErroringFakeSFTP::ERROR_MESSAGE)
      end
    end
  end
end
