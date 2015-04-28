class ProcessOutputDocuments
  def call
    CreateBatch.new.call
    UploadToPrintHouse.new.call(Batch.unprocessed)
  end
end
