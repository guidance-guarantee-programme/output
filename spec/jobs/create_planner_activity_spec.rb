require 'rails_helper'

RSpec.describe CreatePlannerActivity do
  let(:owner) { double(:owner, uid: 'aaaaaa') }
  before do
    allow(Planner::SummaryDocumentActivity).to receive(:new).and_return(summary_document_activity)
  end

  context 'when a posted summary document is requested' do
    let(:appointment_summary) { double(:appointment_summary, reference_number: '1234', requested_digital: false) }
    let(:summary_document_activity) { double(:summary_document_activity, save: true) }

    it 'creates a new summary document activity' do
      expect(Planner::SummaryDocumentActivity).to receive(:new).with(
        booking_request_id: '1234',
        owner_uid: 'aaaaaa',
        delivery_method: 'postal'
      )
      expect(summary_document_activity).to receive(:save)

      described_class.perform_now(appointment_summary, owner)
    end
  end

  context 'when an emailed summary document is requested' do
    let(:appointment_summary) { double(:appointment_summary, reference_number: '1234', requested_digital: true) }
    let(:summary_document_activity) { double(:summary_document_activity, save: true) }

    it 'creates a new summary document activity' do
      expect(Planner::SummaryDocumentActivity).to receive(:new).with(
        booking_request_id: '1234',
        owner_uid: 'aaaaaa',
        delivery_method: 'digital'
      )
      expect(summary_document_activity).to receive(:save)

      described_class.perform_now(appointment_summary, owner)
    end

    context 'when a planner reissue request is made with a given initiator UID' do
      let(:owner) { SecureRandom.uuid }

      it 'sends back the given UID to the Planner API' do
        expect(Planner::SummaryDocumentActivity).to receive(:new).with(
          booking_request_id: '1234',
          owner_uid: owner,
          delivery_method: 'digital'
        )
        expect(summary_document_activity).to receive(:save)

        described_class.perform_now(appointment_summary, owner)
      end
    end
  end
end
