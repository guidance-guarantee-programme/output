class CreateBatch
  def initialize(logger = Rails.logger)
    @logger = logger
  end

  def call
    logger.debug('CreateBatch started')

    create_batch
  ensure
    logger.debug('CreatBatch completed')
  end

  private

  attr_reader :logger

  def create_batch
    unprocessed_appointment_summaries = AppointmentSummary.unprocessed.where(format_preference: :standard)

    logger.info("Unprocessed appointment summaries: #{unprocessed_appointment_summaries.count}")

    return nil if unprocessed_appointment_summaries.empty?

    Batch.create(appointment_summaries: unprocessed_appointment_summaries)
  end
end
