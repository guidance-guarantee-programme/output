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

  context 'with no items to be batched' do
    it { is_expected.to be_nil }
    specify { expect { batch }.to_not change { Batch.count } }
  end

  context 'with items to be batched' do
    let!(:appointment_summaries) { 2.times.map { create_appointment_summary } }

    it { is_expected.to be_a(Batch) }
    specify { expect(batch.appointment_summaries).to eq(appointment_summaries) }

    context 'with some unsupported appointment summaries' do
      shared_examples 'ignore unsupported appointment summaries' do |unsupported_state|
        let(:unsupported) do
          2.times.map do
            create_appointment_summary.tap { |as| as.update_attributes!(unsupported_state) }
          end
        end

        before { appointment_summaries.concat(unsupported) }

        it "should ignore appointment_summaries with #{unsupported_state}" do
          expect(batch.appointment_summaries).not_to include(*unsupported_state)
        end
      end

      include_examples 'ignore unsupported appointment summaries', format_preference: 'braille'
      include_examples 'ignore unsupported appointment summaries', format_preference: 'large_text'
      include_examples 'ignore unsupported appointment summaries', country: Countries.non_uk.sample
    end
  end
end
