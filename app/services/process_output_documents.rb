class ProcessOutputDocuments
  def call
    batch = CreateBatch.new.call

    return nil unless batch

    UploadToPrintHouse.new.call(batch)
  end
end
