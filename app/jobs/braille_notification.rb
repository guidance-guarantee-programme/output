require 'notifications/client'

class BrailleNotification < ApplicationJob
  queue_as :default

  TEMPLATE_ID = '50e47c0e-a2df-43ee-9d2d-d5580b76d958'.freeze
  RECIPIENT   = 'feedback@pensionwise.gov.uk'.freeze

  def perform(appointment_summary, config: Rails.configuration.x.notify)
    payload = notification(appointment_summary)

    Notifications::Client.new(config.secret_id).send_email(payload)
  end

  private

  def notification(appointment_summary)
    {
      email_address: RECIPIENT,
      template_id: TEMPLATE_ID,
      personalisation: {
        reference_number: appointment_summary.reference_number,
        guider_name: appointment_summary.guider_name,
        date_of_appointment: appointment_summary.date_of_appointment.to_fs(:pw_date_long),
        date_of_creation: appointment_summary.created_at.in_time_zone('London')
      }
    }.to_json
  end
end
