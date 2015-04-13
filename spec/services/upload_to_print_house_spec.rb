require 'rails_helper'

RSpec.describe UploadToPrintHouse, '#call' do
  let(:now) { Date.new(2015, 1, 3) }
  let(:csv) { 'c,s,v' }
  let(:csv_path) { '/Data.in/pensionwise_output_20150103.csv' }
  let(:trigger) { 'trigger' }
  let(:trigger_path) { '/Trigger.in/trigger.txt' }

  subject(:uploader) { described_class.new(csv) }

  before do
    allow(uploader).to receive(:upload_file)
    allow(Date).to receive(:today).and_return(now)
    uploader.call
  end

  it 'uploads the CSV' do
    expect(uploader).to have_received(:upload_file).with(csv_path, csv)
  end

  it 'uploads the trigger file' do
    expect(uploader).to have_received(:upload_file).with(trigger_path, trigger)
  end
end
