require 'net/sftp'
require 'stringio'

class PrintHouseSFTPUploader
  def call(jobs)
    Array(jobs).each do |job|
      upload_file(job.payload_path, job.payload)
      upload_file(job.trigger_path, job.trigger)
    end
  end

  private

  def upload_file(path, contents)
    io = StringIO.new(contents)
    Net::SFTP.start(ENV['SFTP_HOST'], ENV['SFTP_USER'], password: ENV['SFTP_PASSWORD']) do |sftp|
      sftp.upload!(io, path)
    end
  end
end
