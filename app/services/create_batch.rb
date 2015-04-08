class CreateBatch
  def call
    unprocessed_appointment_summaries = AppointmentSummary.unprocessed

    return nil if unprocessed_appointment_summaries.empty?

    Batch.create(appointment_summaries: unprocessed_appointment_summaries)
  end
end
