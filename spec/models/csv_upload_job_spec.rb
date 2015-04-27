require 'rails_helper'

RSpec.describe CSVUploadJob do
  let(:batch) { instance_double(Batch, created_at: Time.zone.parse('2015/03/22 12:30:22.564')) }
  let(:csv_upload_job) { CSVUploadJob.new(batch) }

  describe '#payload' do
    let(:csv) { 'c,s,v' }
    let(:csv_renderer) { instance_double(CSVRenderer, render: csv) }

    before do
      appointment_summary = instance_double(AppointmentSummary)
      output_document = instance_double(OutputDocument)

      allow(batch).to receive(:appointment_summaries).and_return([appointment_summary])
      allow(OutputDocument).to receive(:new).with(appointment_summary).and_return(output_document)
      allow(CSVRenderer).to receive(:new).with([output_document]).and_return(csv_renderer)
    end

    subject { csv_upload_job.payload }

    it { is_expected.to eq(csv) }
  end

  describe '#payload_path' do
    subject { csv_upload_job.payload_path }

    it { is_expected.to eq('/Data.in/pensionwise_output_20150322123022564.csv') }
  end
end
