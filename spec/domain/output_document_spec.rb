require 'rails_helper'

RSpec.describe OutputDocument do
  let(:name) { 'Joe Bloggs' }
  let(:appointment_summary) { instance_double(AppointmentSummary, name: name) }
  let(:output_document) { described_class.new(appointment_summary) }

  describe '#html' do
    subject { output_document.html }

    it { is_expected.to include(name) }
  end

  describe '#pdf' do
    subject { PDF::Inspector::Text.analyze(output_document.pdf).strings.join }

    it { is_expected.to include(name) }
  end
end
