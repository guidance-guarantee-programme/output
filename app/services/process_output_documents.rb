class ProcessOutputDocuments
  def call
    batch = CreateBatch.new.call

    return nil unless batch

    csv_upload_job = CSVUploadJob.new(batch)

    UploadToPrintHouse.new(csv_upload_job).call
  end
end
