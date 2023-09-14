require 'notifications/client'

class NotifyDueDiligenceViaEmail < ApplicationJob
  queue_as :default

  def perform(appointment_summary, config: Rails.configuration.x.notify)
    payload  = notification(appointment_summary, config.due_diligence_summary_template_id)
    response = Notifications::Client.new(config.due_diligence_secret_id).send_email(payload)

    appointment_summary.update(
      notification_id: response.id,
      notify_completed_at: nil,
      notify_status: :pending
    )
  end

  private

  def notification(appointment_summary, template_id)
    {
      email_address: appointment_summary.email,
      template_id: template_id,
      personalisation: {
        reference_number: appointment_summary.reference_number,
        unique_reference_number: appointment_summary.unique_reference_number,
        title: appointment_summary.title,
        last_name: appointment_summary.last_name,
        guider_name: appointment_summary.guider_name,
        date_of_appointment: appointment_summary.date_of_appointment.to_s(:pw_date_long)
      }
    }.to_json
  end
end
