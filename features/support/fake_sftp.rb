require 'csv'
require 'net/sftp'
require 'rspec/mocks/standalone'

CSV::Converters[:boolean] = lambda do |value|
  case value.to_s
  when 'true' then true
  when 'false' then false
  else value
  end
end

module FakeSFTP
  def read_uploaded_csv
    path = FakeSFTP.find_path('*.csv')
    contents = FakeSFTP.read(path)

    CSV.parse(contents, headers: true, converters: [:numeric, :date_time, :boolean],
                        header_converters: :symbol, col_sep: '|')
  end

  def self.upload!(io, path)
    uploaded[path] = io.read
  end

  def self.find_path(pattern)
    uploaded.keys.find { |key| File.fnmatch?(pattern, key.to_s) }
  end

  def self.read(path)
    FakeSFTP.uploaded[path]
  end

  def self.uploaded
    @uploaded ||= {}
  end

  def self.clear_uploaded
    uploaded.clear
  end
end

allow(Net::SFTP).to receive(:start).and_yield(FakeSFTP)

Before { FakeSFTP.clear_uploaded }

World(FakeSFTP)
