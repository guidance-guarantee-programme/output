class CreateBatch
  def call
    unprocessed_appointment_summaries = AppointmentSummary.unprocessed.where(format_preference: :standard)

    return nil if unprocessed_appointment_summaries.empty?

    Batch.create(appointment_summaries: unprocessed_appointment_summaries)
  end
end
