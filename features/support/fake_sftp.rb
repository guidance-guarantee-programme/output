# frozen_string_literal: true
require 'net/sftp'
require 'rspec/mocks/standalone'

module FakeSFTP
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
