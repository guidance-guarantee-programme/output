require 'net/sftp'
require 'stringio'

class UploadToPrintHouse
  attr_accessor :csv

  def initialize(csv, logger = Rails.logger)
    @csv = csv
    @logger = logger
  end

  def call
    upload_file("/Data.in/pensionwise_output_#{Time.zone.today.strftime('%Y%m%d')}.csv", csv)
    upload_file('/Trigger.in/trigger.txt', 'trigger')
  end

  private

  attr_reader :logger

  def upload_file(path, contents)
    io = StringIO.new(contents)
    Net::SFTP.start(host, user, password: password) do |sftp|
      logger.info("Connected to #{host}")

      sftp.upload!(io, path)
      logger.info("#{path} uploaded")
    end
  end

  def host
    ENV['SFTP_HOST']
  end

  def user
    ENV['SFTP_USER']
  end

  def password
    ENV['SFTP_PASSWORD']
  end
end
