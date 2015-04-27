class UploadToPrintHouse
  def call(batches)
    jobs = Array(batches).map { |batch| CSVUploadJob.new(batch) }
    PrintHouseSFTPUploader.new.call(jobs)
  end
end
