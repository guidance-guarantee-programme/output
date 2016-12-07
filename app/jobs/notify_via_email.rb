require 'notifications/client'

class NotifyViaEmail < ApplicationJob
  class AttemptingToResendNotification < StandardError
    ERROR_ATTRIBUTES = %w(id email first_name last_name notification_id).freeze

    def initialize(appointment_summary)
      super(appointment_summary.attributes.slice(*ERROR_ATTRIBUTES).inspect)
    end
  end

  queue_as :default

  def perform(appointment_summary, config: Rails.configuration.x.notify)
    raise AttemptingToResendNotification, appointment_summary if appointment_summary.notification_id.present?

    response = notify(
      service_id: config.service_id,
      secret_id: config.secret_id,
      notification: notification(appointment_summary, template_id(appointment_summary, config))
    )

    appointment_summary.update_attributes(notification_id: response.id)
  end

  def notify(service_id:, secret_id:, notification:)
    client = Notifications::Client.new(service_id, secret_id)
    client.send_email(notification.to_json)
  end

  def notification(appointment_summary, template_id)
    {
      to: appointment_summary.email,
      template: template_id,
      personalisation: {
        reference_number: appointment_summary.reference_number,
        title: appointment_summary.title,
        last_name: appointment_summary.last_name,
        guider_name: appointment_summary.guider_name,
        date_of_appointment: appointment_summary.date_of_appointment.to_s(:pw_date_long)
      }
    }
  end

  def template_id(appointment_summary, config)
    appointment_summary.eligible_for_guidance? ? config.appointment_summary_template_id : config.ineligible_template_id
  end
end
