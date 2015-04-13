class ProcessOutputDocuments
  def call
    batch = CreateBatch.new.call

    return nil unless batch

    output_documents = batch.appointment_summaries.map do |appointment_summary|
      OutputDocument.new(appointment_summary)
    end

    csv = CSVRenderer.new(output_documents).render

    UploadToPrintHouse.new(csv).call
  end
end
