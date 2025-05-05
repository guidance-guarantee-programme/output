require 'rails_helper'

RSpec.describe NotifyDueDiligenceViaEmail, '#perform' do
  let(:appointment_summary) { create(:appointment_summary, :due_diligence) }
  let(:config) do
    double(
      :config,
      due_diligence_secret_id: 'secret',
      due_diligence_summary_template_id: 'template'
    )
  end
  let(:client) { double('Notifications::Client', send_email: response) }
  let(:response) { double('Notifications::Client', id: '12345') }

  before do
    allow(Notifications::Client).to receive(:new).and_return(client)
  end

  it 'sends an email notification and assigns notification attributes' do
    expect(client).to receive(:send_email).with(
      {
        email_address: appointment_summary.email,
        template_id: 'template',
        personalisation: {
          reference_number: appointment_summary.reference_number,
          unique_reference_number: '123456/010121',
          title: appointment_summary.title,
          last_name: appointment_summary.last_name,
          guider_name: appointment_summary.guider_name,
          date_of_appointment: appointment_summary.date_of_appointment.to_fs(:pw_date_long)
        }
      }.to_json
    )

    described_class.perform_now(appointment_summary, config: config)

    expect(appointment_summary.reload).to have_attributes(
      notification_id: '12345',
      notify_status: 'pending'
    )
  end
end
