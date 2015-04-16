require 'net/sftp'
require 'stringio'

class UploadToPrintHouse
  attr_accessor :csv

  def initialize(csv)
    @csv = csv
  end

  def call
    upload_file("/Data.in/pensionwise_output_#{Date.today.strftime('%Y%m%d')}.csv", csv)
    upload_file('/Trigger.in/trigger.txt', 'trigger')
  end

  private

  def upload_file(path, contents)
    io = StringIO.new(contents)
    Net::SFTP.start(ENV['SFTP_HOST'], ENV['SFTP_USER'],
                    port: ENV['SFTP_PORT'], password: ENV['SFTP_PASSWORD']) do |sftp|
      sftp.upload!(io, path)
    end
  end
end
