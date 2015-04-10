require 'net/sftp'

class UploadToPrintHouse
  attr_accessor :csv

  def initialize(csv)
    @csv = csv
  end

  def call
  end

  private

  def upload_file(path, contents)
    Net::SFTP.start(ENV['SFTP_HOST'], ENV['SFTP_USER'], password: ENV['SFTP_PASSWORD']) do |sftp|
      sftp.file.open(path, 'w') do |f|
        f.puts contents
      end
    end
  end
end
