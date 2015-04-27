require 'rails_helper'

RSpec.describe PrintHouseSFTPUploader, '#call' do
  let(:now) { Time.zone.local(2015, 1, 3, 5, 2, 4) }
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
    allow(uploader).to receive(:upload_file)
    allow(Time.zone).to receive(:today).and_return(now)
    uploader.call
  end

  it 'uploads the CSV' do
    expect(uploader).to have_received(:upload_file).with(csv_path, csv)
  end

  it 'uploads the trigger file' do
    expect(uploader).to have_received(:upload_file).with(trigger_path, trigger)
  end
end
