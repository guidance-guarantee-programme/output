require 'rails_helper'

RSpec.describe BrailleNotification do
  let(:appointment_summary) { create(:appointment_summary) }
  let(:config) { double(:config, service_id: 'service', secret_id: 'secret') }
  let(:client) { double('Notifications::Client', send_email: true) }

  before do
    allow(Notifications::Client).to receive(:new).and_return(client)
  end

  it 'sends an email notification' do
    expect(client).to receive(:send_email).with(
      {
        email_address: BrailleNotification::RECIPIENT,
        template_id: BrailleNotification::TEMPLATE_ID,
        personalisation: {
          reference_number: appointment_summary.reference_number,
          guider_name: appointment_summary.guider_name,
          date_of_appointment: appointment_summary.date_of_appointment.to_fs(:pw_date_long),
          date_of_creation: appointment_summary.created_at.in_time_zone('London')
        }
      }.to_json
    )

    described_class.perform_now(appointment_summary, config: config)
  end
end
