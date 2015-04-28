class UploadToPrintHouse
  attr_reader :uploader

  def initialize
    @uploader = PrintHouseSFTPUploader.new
    @uploader.on(:upload_success, &method(:on_upload_success))
  end

  def call(batches)
    jobs = create_upload_jobs(batches)
    uploader.call(jobs) unless jobs.empty?
  end

  private

  def create_upload_jobs(batches)
    Array(batches).map { |batch| CSVUploadJob.new(batch) }
  end

  def on_upload_success(job)
    batch = job.batch
    batch.mark_as_uploaded if batch
  end
end
