require 'rails_helper'

RSpec.describe OutputDocumentMailerJob, '#perform' do
  let(:appointment_summary) { double }
  let(:output_document_pdf) { double }
  let(:output_document) { instance_double(OutputDocument, pdf: output_document_pdf) }
  let(:output_document_mailer) { double(deliver_now: true) }

  subject(:perform_job) { described_class.new.perform(appointment_summary) }

  before do
    allow(OutputDocument).to receive(:new).with(appointment_summary).and_return(output_document)
  end

  it 'delivers the mail' do
    expect(OutputDocumentMailer).to receive(:issue)
      .with(appointment_summary, output_document_pdf)
      .and_return(output_document_mailer)
    perform_job
  end
end
