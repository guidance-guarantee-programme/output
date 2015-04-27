class CreateBatch
  def call
    unbatched_appointment_summaries = AppointmentSummary.unbatched
                                      .where(format_preference: :standard)
                                      .where(country: Countries.uk)

    return nil if unbatched_appointment_summaries.empty?

    Batch.create(appointment_summaries: unbatched_appointment_summaries)
  end
end
