require 'rails_helper'

RSpec.describe OutputDocument do
  let(:name) { 'Joe Bloggs' }
  let(:output_document) { described_class.new(appointment_summary) }
  let(:appointment_summary) do
    instance_double(AppointmentSummary,
                    name: name,
                    date_of_appointment: Date.today,
                    value_of_pension_pots: 35_000,
                    income_in_retirement: :pension)
  end

  describe '#html' do
    subject { output_document.html }

    it { is_expected.to include(name) }
  end

  describe '#pdf' do
    subject { PDF::Inspector::Text.analyze(output_document.pdf).strings.join }

    it { is_expected.to include(name) }
  end
end
