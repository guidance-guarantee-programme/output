require 'notifications/client'
require 'telephone_appointments'

class NotifyDelivery
  def initialize(client = Notifications::Client.new(ENV['NOTIFY_SECRET_ID']))
    @client = client
  end

  def call(appointment_summary)
    response = client.get_notification(appointment_summary.notification_id)

    process_response(response, appointment_summary)
    notify_tap(appointment_summary)
  rescue Notifications::Client::RequestError
    appointment_summary.stop_checking!
  end

  private

  def process_response(response, appointment_summary)
    appointment_summary.update_attributes(
      notify_completed_at: response.completed_at,
      notify_status: map_status(response)
    )
  end

  def notify_tap(appointment_summary)
    return unless appointment_summary.failed? && appointment_summary.notify_completed_at?

    TelephoneAppointments::DroppedSummaryDocumentActivity.new(appointment_summary.to_param).save
  end

  def map_status(response)
    case response.status
    when 'delivered'
      response.status
    when /-failure\Z/
      'failed'
    else
      'pending'
    end
  end

  attr_reader :client
end
