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

  before do
    allow(Net::SFTP).to receive(:start).and_yield(sftp)
    uploader.call
  end

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
