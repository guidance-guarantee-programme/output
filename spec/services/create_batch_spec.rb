require 'rails_helper'

RSpec.describe CreateBatch, '#call' do
  subject(:batch) { described_class.new.call }

  def create_appointment_summary
    AppointmentSummary.create(
      title: 'Mr', last_name: 'Bloggs', date_of_appointment: Time.zone.today,
      reference_number: '123', guider_name: 'Jimmy', guider_organisation: 'tpas',
      address_line_1: '29 Acacia Road', town: 'Beanotown', postcode: 'BT7 3AP',
      has_defined_contribution_pension: 'yes', income_in_retirement: 'pension',
      format_preference: 'standard')
  end

  context 'with no items to be processed' do
    it { is_expected.to be_nil }
    specify { expect { batch }.to_not change { Batch.count } }
  end

  context 'with items to be processed' do
    let!(:appointment_summaries) { 2.times.map { create_appointment_summary } }

    it { is_expected.to be_a(Batch) }
    specify { expect(batch.appointment_summaries).to eq(appointment_summaries) }

    context 'where some have currently unsupported formats' do
      let(:braille_summaries) do
        2.times.map do
          create_appointment_summary.tap { |as| as.update_attributes!(format_preference: 'braille') }
        end
      end

      let(:large_text_summaries) do
        2.times.map do
          create_appointment_summary.tap { |as| as.update_attributes!(format_preference: 'large_text') }
        end
      end

      before do
        appointment_summaries.concat(braille_summaries)
        appointment_summaries.concat(large_text_summaries)
      end

      it 'should ignore braille appointment_summaries' do
        expect(batch.appointment_summaries).not_to include(*braille_summaries)
      end

      it 'should ignore large_text appointment_summaries' do
        expect(batch.appointment_summaries).not_to include(*large_text_summaries)
      end
    end
  end
end
