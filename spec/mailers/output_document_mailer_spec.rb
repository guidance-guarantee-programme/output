require 'rails_helper'

RSpec.describe OutputDocumentMailer, '.issue', type: :mailer do
  let(:email) { 'a@b.com' }
  let(:appointment_summary) { AppointmentSummary.new(email_address: email, date_of_appointment: Date.today) }
  let(:output_document) { 'output document' }
  let(:deliveries) { ActionMailer::Base.deliveries }
  let(:sent_mail) { deliveries.first }
  let(:attachment) { sent_mail.attachments.first }

  before do
    allow(OutputDocument).to receive(:new)
      .with(appointment_summary).and_return(output_document)
    described_class.issue(appointment_summary, output_document).deliver_now
  end

  specify { expect(deliveries.count).to eql(1) }
  specify { expect(sent_mail.to).to include(email) }
  specify { expect(sent_mail.attachments.count).to eql(1) }
  specify { expect(attachment.body.raw_source).to eql(output_document) }
end
