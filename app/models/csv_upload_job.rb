class CSVUploadJob
  attr_reader :batch

  def initialize(batch)
    @batch = batch
  end

  def payload
    output_documents = batch.appointment_summaries.map do |appointment_summary|
      OutputDocument.new(appointment_summary)
    end

    CSVRenderer.new(output_documents).render
  end

  def payload_path
    timestamp = batch.created_at.strftime('%Y%m%d%H%M%S%L')
    "/Data.in/pensionwise_output_#{timestamp}.csv"
  end
end
