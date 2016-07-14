# frozen_string_literal: true
class CreateBatch
  def call
    unbatched_appointment_summaries = AppointmentSummary.unbatched
                                                        .excluding_digital_by_default
                                                        .where.not(format_preference: 'braille')

    return nil if unbatched_appointment_summaries.empty?

    Batch.create(appointment_summaries: unbatched_appointment_summaries).tap do |b|
      logger.info("Batch #{b.id} created with #{b.appointment_summaries.count} item(s)")
    end
  end

  def logger
    Rails.logger
  end
end
