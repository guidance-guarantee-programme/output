# frozen_string_literal: true
require 'notifications/client'

class NotifyViaEmail < ActiveJob::Base
  class AttemptingToResendNotification < StandardError; end

  queue_as :default

  def perform(appointment_summary, config: Rails.configuration.x.notify)
    raise AttemptingToResendNotification, appointment_summary.inspect if appointment_summary.notification_id.present?

    response = notify(
      service_id: config.service_id,
      secret_id: config.secret_id,
      notification: notification(appointment_summary, config)
    )

    appointment_summary.update_attributes(notification_id: response.id)
  end

  def notify(service_id:, secret_id:, notification:)
    client = Notifications::Client.new(service_id, secret_id)
    client.send_email(notification.to_json)
  end

  def notification(appointment_summary, config)
    {
      to: appointment_summary.email,
      template: config.appointment_summary_template_id,
      personalisation: {
        reference_number: appointment_summary.reference_number,
        title: appointment_summary.title,
        last_name: appointment_summary.last_name,
        guider_name: appointment_summary.guider_name,
        date_of_appointment: appointment_summary.date_of_appointment.to_s(:pw_date_long)
      }
    }
  end
end
