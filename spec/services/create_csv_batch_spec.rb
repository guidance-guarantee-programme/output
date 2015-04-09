require 'rails_helper'

RSpec.describe 'create CSV batch' do
  let!(:appointment_summaries) { 2.times.map { create_appointment_summary } }
  let(:batch) { CreateBatch.new.call }
  let(:output_documents) do
    batch.appointment_summaries.map do |appointment_summary|
      OutputDocument.new(appointment_summary)
    end
  end
  let(:csv) { CSVRenderer.new(output_documents).render }

  def create_appointment_summary
    AppointmentSummary.create(
      title: 'Mr', last_name: 'Bloggs', date_of_appointment: Date.today,
      reference_number: '123', guider_name: 'Jimmy', guider_organisation: 'tpas',
      address_line_1: '29 Acacia Road', town: 'Beanotown', postcode: 'BT7 3AP',
      has_defined_contribution_pension: 'yes', income_in_retirement: 'pension')
  end

  it 'writes the CSV to disk' do
    puts csv
  end
end
