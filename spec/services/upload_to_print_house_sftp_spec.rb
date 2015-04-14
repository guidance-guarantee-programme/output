require 'rails_helper'

RSpec.describe UploadToPrintHouse, 'SFTP' do
  let(:env) do
    {
      'SFTP_HOST' => 'localhost',
      'SFTP_PORT' => '3373',
      'SFTP_USER' => 'ignored',
      'SFTP_PASSWORD' => 'ignored'
    }
  end
  let(:csv) { 'c,s,v' }
  let(:tmp_dir) { Dir.mktmpdir }
  let(:data_dir) { File.join(tmp_dir, 'Data.in') }
  let(:trigger_dir) { File.join(tmp_dir, 'Trigger.in') }
  let(:key) { Rails.root.join('spec', 'fixtures', 'insecure-private-key') }
  let(:cmd) { "sftpserver -k #{key}" }
  let(:sftp_server) do
    Dir.chdir(tmp_dir) do
      IO.popen(env, cmd)
    end
  end
  let(:pid) { sftp_server.pid }

  before do
    ENV.update(env)
    Dir.mkdir(data_dir)
    Dir.mkdir(trigger_dir)
    sftp_server
    sleep(1)
    UploadToPrintHouse.new(csv).call
  end

  after do
    Process.kill('KILL', pid)
    FileUtils.remove_entry(tmp_dir)
  end

  describe 'uploaded CSV' do
    subject { File.read(Dir[File.join(data_dir, '*.csv')].first) }

    it { is_expected.to eq(csv) }
  end

  describe 'uploaded trigger file' do
    subject { File.read(File.join(trigger_dir, 'trigger.txt')) }

    it { is_expected.to_not be_empty }
  end
end
