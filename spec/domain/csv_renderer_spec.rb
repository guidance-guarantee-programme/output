require 'rails_helper'

RSpec.describe CSVRenderer do
  let(:headers) do
    'id|format|variant|attendee_name|attendee_address_line_1|' \
    'attendee_address_line_2|attendee_address_line_3|attendee_town|' \
    'attendee_county|attendee_postcode|lead|guider_first_name|' \
    'guider_organisation|appointment_reference|appointment_date|' \
    'value_of_pension_pots|income_in_retirement|continue_working|unsure|' \
    'leave_inheritance|wants_flexibility|wants_security|wants_lump_sum|' \
    "poor_health\n"
  end
  let(:csv) { 'csv' }
  let(:output_document) { double(csv: csv) }
  let(:csv_renderer) { described_class.new([output_document]) }

  describe '#header_row' do
    subject { csv_renderer.header_row }

    it { is_expected.to eq(headers) }
  end

  describe '#render' do
    subject { csv_renderer.render }

    it { is_expected.to eq(headers + csv) }
  end
end
