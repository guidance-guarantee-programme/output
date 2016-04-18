# frozen_string_literal: true
require 'rails_helper'

RSpec.describe TransliteratedAppointmentSummary do
  transliterated_fields = %i(first_name
                             last_name
                             address_line_1
                             address_line_2
                             address_line_3
                             town
                             county
                             postcode
                             country
                             guider_name)

  transliterated_fields.each do |field|
    describe ".#{field}" do
      subject do
        appointment_summary = instance_double(AppointmentSummary, field => 'abc123!@$%àéïöüçß')

        described_class.new(appointment_summary).public_send(field)
      end

      it 'approximates non-ASCII characters' do
        is_expected.to eq('abc123!@$%aeioucss')
      end
    end
  end
end
