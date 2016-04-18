# frozen_string_literal: true
class ProcessOutputDocuments
  attr_reader :tags

  def initialize
    @tags = [self.class, SecureRandom.uuid]
  end

  def call
    logger.push_tags(tags)
    logger.info('Start')

    CreateBatch.new.call
    upload_all(Batch.unprocessed)

    logger.info('End')
  ensure
    logger.pop_tags(tags.size)
  end

  private

  def upload_all(batches)
    Array(batches).each { |batch| upload(batch) }
  end

  def upload(batch)
    logger.info("Processing batch #{batch.id}")

    job = CSVUploadJob.new(batch)
    UploadToPrintHouse.new(job).call
    batch.mark_as_uploaded
  end

  def logger
    Rails.logger
  end
end
