class CreatePlannerActivity < ApplicationJob
  queue_as :default

  def perform(appointment_summary, owner)
    summary = Planner::SummaryDocumentActivity.new(
      booking_request_id: appointment_summary.reference_number,
      owner_uid: owner_uid(owner),
      delivery_method: appointment_summary.requested_digital ? 'digital' : 'postal'
    )

    summary.save
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
