require 'rails_helper'

RSpec.describe AppointmentSummaryCsv do
  let(:appointment) { build_stubbed(:appointment_summary) }
  let(:separator) { ',' }

  subject { described_class.new(appointment).call.lines }

  describe '#csv' do
    it 'generates headings' do
      expect(subject.first.chomp.split(separator)).to match_array(
        %w(
          id
          date_of_appointment
          value_of_pension_pots
          guider_name
          reference_number
          address_line_1
          address_line_2
          address_line_3
          town
          county
          postcode
          country
          title
          first_name
          last_name
          format_preference
          appointment_type
          has_defined_contribution_pension
        )
      )
    end

    it 'generates correctly mapped rows' do
      expect(subject.last.chomp.split(separator)).to match_array(
        [
          appointment.to_param,
          appointment.date_of_appointment.to_s,
          appointment.value_of_pension_pots.to_s,
          appointment.guider_name,
          appointment.reference_number,
          appointment.address_line_1,
          appointment.address_line_2,
          appointment.address_line_3,
          appointment.town,
          appointment.county,
          appointment.postcode,
          appointment.country,
          appointment.title,
          appointment.first_name,
          appointment.last_name,
          appointment.format_preference,
          appointment.appointment_type,
          appointment.has_defined_contribution_pension
        ]
      )
    end
  end
end
