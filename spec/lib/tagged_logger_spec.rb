require 'rails_helper'
require 'tagged_logger'

RSpec.describe TaggedLogger do
  let(:klass_name) { 'MyGreatClass' }
  let(:klass) do
    klass = Class.new do
      include TaggedLogger
    end
    Object.const_set(klass_name, klass) unless Object.const_defined?(klass_name)
    Object.const_get(klass_name)
  end
  let(:logger) { double }
  let(:message) { 'message' }

  before do
    described_class.logger = logger
  end

  subject { klass.new }

  %i(debug info warn error fatal).each do |level|
    describe "##{level}" do
      it 'tags the log entry' do
        expect(logger).to receive(level).with("[#{klass_name}] #{message}")
        subject.public_send(level, message)
      end
    end
  end
end
