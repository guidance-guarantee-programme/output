# frozen_string_literal: true
require 'net/sftp'
require 'stringio'

class UploadToPrintHouse
  attr_accessor :job

  def initialize(job)
    @job = job
  end

  def call
    Retriable.retriable(tries: 6, on_retry: method(:on_retry)) do
      upload_file(job.payload_path, job.payload)
      upload_file(job.trigger_path, job.trigger)
    end
  end

  private

  def upload_file(path, contents)
    logger.info("Uploading #{path}")

    io = StringIO.new(contents)
    Net::SFTP.start(ENV['SFTP_HOST'], ENV['SFTP_USER'], password: ENV['SFTP_PASSWORD']) do |sftp|
      sftp.upload!(io, path)
    end
  end

  def logger
    Rails.logger
  end

  def on_retry(exception, try, _, _)
    logger.warn "Upload error (attempt #{try}). #{exception.class}: '#{exception.message}'"
  end
end
