require 'rails_helper'

RSpec.describe NotifyDelivery, '#call' do
  let(:telephone_appointment) { false }
  let(:appointment_summary) do
    create(:notify_delivered_appointment_summary, telephone_appointment: telephone_appointment)
  end
  let(:client) { instance_double(Notifications::Client) }

  subject { described_class.new(client).call(appointment_summary) }

  context 'when the notification failed' do
    before do
      allow(client).to receive(:get_notification).and_return(
        double(completed_at: nil, status: 'permanent-failure')
      )
    end

    it 'marks the summary as failed' do
      subject

      expect(appointment_summary).to be_failed
    end
  end

  context 'when the notification failed and notify returned a `completed_at` timestamp' do
    let(:activity) { double(save: true) }

    before do
      allow(client).to receive(:get_notification).and_return(
        double(completed_at: Time.zone.now, status: 'permanent-failure')
      )
    end

    context 'and the appointment was face to face' do
      it 'does not notify TAP with an activity entry' do
        expect(
          TelephoneAppointments::DroppedSummaryDocumentActivity
        ).not_to receive(:new)

        subject

        expect(activity).not_to have_received(:save)
      end
    end
    context 'and the appointment was via telephone' do
      let(:telephone_appointment) { true }

      it 'notifies TAP with an activity entry' do
        expect(
          TelephoneAppointments::DroppedSummaryDocumentActivity
        ).to receive(:new).with(appointment_summary.reference_number) { activity }

        subject

        expect(activity).to have_received(:save)
      end
    end
  end

  context 'when the notification was delivered' do
    before do
      allow(client).to receive(:get_notification).and_return(
        double(completed_at: Time.zone.now, status: 'delivered')
      )
    end

    it 'marks the summary as delivered' do
      subject

      expect(appointment_summary.notify_completed_at).to be_present
      expect(appointment_summary).to be_delivered
    end
  end

  context 'when the notification is not found' do
    before do
      allow(client).to receive(:get_notification).and_raise(
        Notifications::Client::RequestError.new(
          double(code: 404, body: '{"errors":[]}')
        )
      )
    end

    it 'marks the summary so it is not checked again' do
      subject

      expect(appointment_summary.notify_completed_at).to be_present
      expect(appointment_summary).to be_ignoring
    end
  end
end
