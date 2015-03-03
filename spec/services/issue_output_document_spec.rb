require 'rails_helper'

RSpec.describe IssueOutputDocument, '#call' do
  let(:email_address) { '' }
  let(:appointment_summary) { instance_double(AppointmentSummary, email_address: email_address) }

  subject(:call_service) { described_class.new(appointment_summary).call }

  context 'without an email address' do
    it 'does not issue the output document' do
      expect(OutputDocumentMailerJob).to_not receive(:perform_later)
      call_service
    end
  end

  context 'with an email address' do
    let(:email_address) { 'a@b.com' }

    it 'issues the output document' do
      expect(OutputDocumentMailerJob).to receive(:perform_later)
        .with(appointment_summary)
      call_service
    end
  end
end
