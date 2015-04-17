require 'rails_helper'

RSpec.describe CreateBatch, '#call' do
  subject(:batch) { described_class.new.call }

  def create_appointment_summary
    AppointmentSummary.create(
      title: 'Mr', last_name: 'Bloggs', date_of_appointment: Time.zone.today,
      reference_number: '123', guider_name: 'Jimmy', guider_organisation: 'tpas',
      address_line_1: '29 Acacia Road', town: 'Beanotown', postcode: 'BT7 3AP',
      has_defined_contribution_pension: 'yes', income_in_retirement: 'pension')
  end

  context 'with no items to be processed' do
    it { is_expected.to be_nil }
    specify { expect { batch }.to_not change { Batch.count } }
  end

  context 'with items to be processed' do
    let(:appointment_summaries) { 2.times.map { create_appointment_summary } }

    before do
      allow(AppointmentSummary)
        .to receive(:unprocessed)
        .and_return(appointment_summaries)
    end

    it { is_expected.to be_a(Batch) }
    specify { expect(batch.appointment_summaries).to eq(appointment_summaries) }
  end
end
