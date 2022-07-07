require 'rails_helper'

RSpec.describe CreateTapActivity do
  let(:owner) { double(:owner, uid: 'aaaaaa') }
  before do
    allow(TelephoneAppointments::SummaryDocumentActivity).to receive(:new).and_return(summary_document_activity)
  end

  context 'when a posted summary document is requested' do
    let(:appointment_summary) { double(:appointment_summary, reference_number: '1234', requested_digital: false) }
    let(:summary_document_activity) { double(:summary_document_activity, save: true) }

    it 'creates a new summary document activity' do
      expect(TelephoneAppointments::SummaryDocumentActivity).to receive(:new).with(
        appointment_id: '1234',
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
      expect(TelephoneAppointments::SummaryDocumentActivity).to receive(:new).with(
        appointment_id: '1234',
        owner_uid: 'aaaaaa',
        delivery_method: 'digital'
      )
      expect(summary_document_activity).to receive(:save)

      described_class.perform_now(appointment_summary, owner)
    end

    context 'when a TAP reissue request is made with a given initiator UID' do
      let(:owner) { SecureRandom.uuid }

      it 'sends back the given UID to the TAP API' do
        expect(TelephoneAppointments::SummaryDocumentActivity).to receive(:new).with(
          appointment_id: '1234',
          owner_uid: owner,
          delivery_method: 'digital'
        )
        expect(summary_document_activity).to receive(:save)

        described_class.perform_now(appointment_summary, owner)
      end
    end
  end

  context 'when the summary document fails to save' do
    let(:appointment_summary) { double(:appointment_summary, reference_number: '1234', requested_digital: false) }
    let(:summary_document_activity) do
      double(:summary_document_activity, save: false, errors: { 'owner_id' => "can't be blank" })
    end

    it 'reports an error via bugsnag' do
      expect(Bugsnag).to receive(:notify).with(an_instance_of(described_class::UnableToCreateSummaryDocumentActivity))
      described_class.perform_now(appointment_summary, owner)
    end
  end
end
