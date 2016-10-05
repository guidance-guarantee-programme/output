require 'rails_helper'

RSpec.describe NotifyViaEmail do
  let(:appointment_summary) { create(:appointment_summary) }
  let(:config) do
    double(
      :config,
      service_id: 'service',
      secret_id: 'secret',
      appointment_summary_template_id: 'template',
      ineligible_template_id: 'ineligible_template'
    )
  end
  let(:client) { double('Notifications::Client', send_email: response) }
  let(:response) { double('Notifications::Client', id: '12345') }

  before do
    allow(Notifications::Client).to receive(:new).and_return(client)
  end

  context 'when the customer has a DC pension' do
    it 'sends a standard email notification' do
      expect(client).to receive(:send_email).with(
        {
          to: appointment_summary.email,
          template: 'template',
          personalisation: {
            reference_number: appointment_summary.reference_number,
            title: appointment_summary.title,
            last_name: appointment_summary.last_name,
            guider_name: appointment_summary.guider_name,
            date_of_appointment: appointment_summary.date_of_appointment.to_s(:pw_date_long)
          }
        }.to_json
      )

      described_class.perform_now(appointment_summary, config: config)
    end
  end

  context 'when the customer does not have a DC pension' do
    let(:appointment_summary) { create(:appointment_summary, has_defined_contribution_pension: 'no') }

    it 'sends an ineligible email notification' do
      expect(client).to receive(:send_email).with(
        {
          to: appointment_summary.email,
          template: 'ineligible_template',
          personalisation: {
            reference_number: appointment_summary.reference_number,
            title: appointment_summary.title,
            last_name: appointment_summary.last_name,
            guider_name: appointment_summary.guider_name,
            date_of_appointment: appointment_summary.date_of_appointment.to_s(:pw_date_long)
          }
        }.to_json
      )

      described_class.perform_now(appointment_summary, config: config)
    end
  end

  it 'stores the notification id' do
    described_class.perform_now(appointment_summary, config: config)
    appointment_summary.reload
    expect(appointment_summary.notification_id).to eq('12345')
  end

  it 'raises an error if a notification has already been sent' do
    appointment_summary.notification_id = 'already send'
    expect do
      described_class.perform_now(appointment_summary, config: config)
    end.to raise_error(described_class::AttemptingToResendNotification)
  end
end
