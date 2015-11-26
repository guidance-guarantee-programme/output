require 'rails_helper'

RSpec.describe CSVRenderer, '#render' do
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
      appointment_date: 'appointment_date'
    }
  end
  let(:output_document) { instance_double(OutputDocument, attributes) }
  let(:headers) do
    'id|format|variant|attendee_name|attendee_address_line_1|' \
    'attendee_address_line_2|attendee_address_line_3|attendee_town|' \
    'attendee_county|attendee_postcode|lead|guider_first_name|' \
    'guider_organisation|appointment_reference|appointment_date'
  end
  let(:row) do
    'id|format|variant|attendee_name|attendee_address_line_1|attendee_address_line_2|' \
    'attendee_address_line_3|attendee_town|attendee_county|attendee_postcode|' \
    'lead|guider_first_name|guider_organisation|appointment_reference|appointment_date'
  end

  subject(:csv) { described_class.new([output_document]).render }

  it { is_expected.to eql("#{headers}\n#{row}") }

  describe 'special characters' do
    let(:attendee_name) { "  All |the\n special characters  " }

    before do
      attributes[:attendee_name] = attendee_name
    end

    subject { csv.split("\n").last }

    it { is_expected.to match(/\|All the special characters\|/) }
  end
end
