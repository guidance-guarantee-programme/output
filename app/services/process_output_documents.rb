class ProcessOutputDocuments
  def call
    CreateBatch.new.call
    batches = Array(Batch.unprocessed)

    return nil if batches.empty?

    UploadToPrintHouse.new.call(batches)
  end
end
