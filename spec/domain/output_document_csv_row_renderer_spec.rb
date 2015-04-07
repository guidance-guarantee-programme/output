require 'rails_helper'

RSpec.describe OutputDocument::CSVRowRenderer, '#render' do
  let(:attributes) do
    {
      id: 'id',
      format: 'format',
      variant: 'variant',
      attendee_name: 'attendee_name',
      attendee_address_line_1: 'attendee_address_line_1',
      attendee_address_line_2: 'attendee_address_line_2',
      attendee_address_line_3: 'attendee_address_line_3',
      attendee_town: 'attendee_town',
      attendee_county: 'attendee_county',
      attendee_postcode: 'attendee_postcode',
      lead: 'lead',
      guider_first_name: 'guider_first_name',
      guider_organisation: 'guider_organisation',
      appointment_reference: 'appointment_reference',
      appointment_date: 'appointment_date',
      value_of_pension_pots: 'value_of_pension_pots',
      income_in_retirement: 'income_in_retirement',
      continue_working: false,
      unsure: false,
      leave_inheritance: false,
      wants_flexibility: false,
      wants_security: false,
      wants_lump_sum: false,
      poor_health: false
    }
  end
  let(:output_document) { instance_double(OutputDocument, attributes) }
  let(:csv) do
    'id|format|variant|attendee_name|attendee_address_line_1|attendee_address_line_2|' \
    'attendee_address_line_3|attendee_town|attendee_county|attendee_postcode|' \
    'lead|guider_first_name|guider_organisation|appointment_reference|appointment_date|' \
    "value_of_pension_pots|income_in_retirement|false|false|false|false|false|false|false\n"
  end

  subject { described_class.new(output_document).render }

  it { is_expected.to eq(csv) }
end
