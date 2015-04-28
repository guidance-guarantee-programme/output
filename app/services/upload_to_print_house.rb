class UploadToPrintHouse
  attr_reader :uploader

  def initialize
    @uploader = PrintHouseSFTPUploader.new
    @uploader.on(:upload_success, &method(:on_upload_success))
  end

  def call(batches)
    jobs = Array(batches).map { |batch| CSVUploadJob.new(batch) }
    uploader.call(jobs)
  end

  private

  def on_upload_success(job)
    batch = job.batch
    batch.mark_as_uploaded if batch
  end
end
