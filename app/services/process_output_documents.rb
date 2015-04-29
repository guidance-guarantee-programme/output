class ProcessOutputDocuments
  def call
    CreateBatch.new.call
    upload_all(Batch.unprocessed)
  end

  private

  def upload_all(batches)
    Array(batches).each { |batch| upload(batch) }
  end

  def upload(batch)
    job = CSVUploadJob.new(batch)
    UploadToPrintHouse.new(job).call
    batch.mark_as_uploaded
  end
end
