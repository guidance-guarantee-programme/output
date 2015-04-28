require 'net/sftp'
require 'stringio'

class PrintHouseSFTPUploader
  include Wisper::Publisher

  def call(jobs)
    Array(jobs).each { |job| process(job) }
  end

  private

  def process(job)
    upload_file(job.payload_path, job.payload)
    upload_file(job.trigger_path, job.trigger)
    broadcast(:upload_succeeded, job)
  rescue => error
    broadcast(:upload_failed, job, error)
  end

  def upload_file(path, contents)
    io = StringIO.new(contents)
    Net::SFTP.start(ENV['SFTP_HOST'], ENV['SFTP_USER'], password: ENV['SFTP_PASSWORD']) do |sftp|
      sftp.upload!(io, path)
    end
  end
end
