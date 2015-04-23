class ProcessOutputDocuments
  def initialize(logger = Rails.logger)
    @logger = logger
  end

  def call
    run_id = SecureRandom.uuid
    logger.tagged('ProcessOutputDocuments', run_id) do |logger|
      Runner.new(logger).call
    end
  end

  private

  attr_reader :logger

  class Runner
    attr_reader :logger

    def initialize(logger)
      @logger = logger
    end

    def call
      logger.info('Started ProcessOutputDocuments')

      process_output_documents
    rescue => error
      log_error(error)
      raise
    ensure
      success_or_failure = error ? 'failure' : 'success'
      logger.info("Completed ProcessOutputDocuments (#{success_or_failure})")
    end

    private

    def process_output_documents
      batch = CreateBatch.new(logger).call

      return nil unless batch

      output_documents = batch.appointment_summaries.map do |appointment_summary|
        OutputDocument.new(appointment_summary)
      end

      csv = CSVRenderer.new(output_documents).render

      UploadToPrintHouse.new(csv, logger).call
    end

    def log_error(error)
      logger.error("#{error.backtrace.first}: #{error.message} (#{error.class})")
      error.backtrace.drop(1).map { |s| "\t#{s}" }
        .each { |e| logger.error(e) }
    end
  end
end
