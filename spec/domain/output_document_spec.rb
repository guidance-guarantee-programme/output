require 'rails_helper'

RSpec.describe OutputDocument do
  let(:name) { 'Joe Bloggs' }
  let(:output_document) { described_class.new(appointment_summary) }
  let(:appointment_summary) do
    instance_double(AppointmentSummary,
                    name: name,
                    date_of_appointment: Date.today,
                    value_of_pension_pots: 35_000,
                    income_in_retirement: :pension,
                    guider_name: 'A Guider',
                    guider_organisation: 'tpas')
  end

  describe '#html' do
    subject { output_document.html }

    it { is_expected.to include(name) }
  end
end
