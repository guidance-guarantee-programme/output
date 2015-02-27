require 'rails_helper'

RSpec.describe OutputDocumentMailer, '.guidance_record', type: :mailer do
  let(:email) { 'a@b.com' }
  let(:appointment_summary) { instance_double(AppointmentSummary, email_address: email) }
  let(:output_document_content) { 'output document' }
  let(:output_document) { double(content: output_document_content) }
  let(:deliveries) { ActionMailer::Base.deliveries }
  let(:sent_mail) { deliveries.first }
  let(:attachment) { sent_mail.attachments.first }

  before do
    allow(OutputDocument).to receive(:new)
      .with(appointment_summary).and_return(output_document)
    described_class.guidance_record(appointment_summary).deliver_now
  end

  specify { expect(deliveries.count).to eql(1) }
  specify { expect(sent_mail.to).to include(email) }
  specify { expect(sent_mail.attachments.count).to eql(1) }
  specify { expect(attachment.body.raw_source).to eql(output_document_content) }
end
