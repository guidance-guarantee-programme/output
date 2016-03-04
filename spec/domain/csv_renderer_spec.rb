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
      attendee_country: 'attendee_country',
      lead: 'lead',
      supplementary_benefits: false,
      supplementary_debt: false,
      supplementary_ill_health: false,
      supplementary_defined_benefit_pensions: false
    }
  end
  let(:output_document) { instance_double(OutputDocument, attributes) }
  let(:headers) do
    'id|format|variant|attendee_name|attendee_address_line_1|' \
    'attendee_address_line_2|attendee_address_line_3|attendee_town|' \
    'attendee_county|attendee_postcode|attendee_country|lead|supplementary_benefits|' \
    'supplementary_debt|supplementary_ill_health|' \
    'supplementary_defined_benefit_pensions'
  end
  let(:row) do
    'id|format|variant|attendee_name|attendee_address_line_1|attendee_address_line_2|' \
    'attendee_address_line_3|attendee_town|attendee_county|attendee_postcode|attendee_country|' \
    'lead|false|false|false|false'
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
