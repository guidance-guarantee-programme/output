require 'rails_helper'

RSpec.describe IssueOutputDocument, '#call' do
  let(:email_address) { '' }
  let(:appointment_summary) { instance_double(AppointmentSummary, email_address: email_address) }
  let(:output_document_pdf) { double }
  let(:output_document) { instance_double(OutputDocument, pdf: output_document_pdf) }
  let(:output_document_mailer) { double(deliver_later: true) }

  subject(:call_service) { described_class.new(appointment_summary).call }

  before do
    allow(OutputDocument).to receive(:new).with(appointment_summary).and_return(output_document)
  end

  context 'without an email address' do
    it 'does not issue the output document' do
      expect(OutputDocumentMailer).to_not receive(:issue)
      call_service
    end
  end

  context 'with an email address' do
    let(:email_address) { 'a@b.com' }

    it 'issues the output document' do
      expect(OutputDocumentMailer).to receive(:issue)
        .with(appointment_summary, output_document_pdf)
        .and_return(output_document_mailer)
      call_service
    end
  end
end
