require 'notifications/client'

class CreateTapActivity < ApplicationJob
  class UnableToCreateSummaryDocumentActivity < StandardError; end

  rescue_from(CreateTapActivity::UnableToCreateSummaryDocumentActivity) do |exception|
    Bugsnag.notify(exception)
  end

  queue_as :default

  def perform(appointment_summary, owner)
    telephone_appointment = TelephoneAppointments::SummaryDocumentActivity.new(
      appointment_id: appointment_summary.reference_number,
      owner_uid: owner_uid(owner),
      delivery_method: appointment_summary.requested_digital ? 'digital' : 'postal'
    )

    return if telephone_appointment.save

    raise UnableToCreateSummaryDocumentActivity, <<~MESSAGE
      Appointment: #{appointment_summary.reference_number}
      Errors: #{telephone_appointment.errors.inspect}
    MESSAGE
  end

  private

  def owner_uid(owner)
    if owner.respond_to?(:uid)
      owner.uid
    else
      owner
    end
  end
end
