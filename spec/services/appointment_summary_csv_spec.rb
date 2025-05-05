require 'rails_helper'

RSpec.describe AppointmentSummaryCsv do
  let(:user) { create(:user, organisation_content_id: 'content-id') }
  let(:appointment) { create(:appointment_summary, user: user) }
  let(:separator) { ',' }

  subject { described_class.new(appointment).call.lines }

  describe '#csv' do
    it 'generates headings' do
      expect(subject.first.chomp.split(separator)).to match_array(
        %w(
          id
          telephone_appointment
          organisation_id
          date_of_appointment
          value_of_pension_pots_is_approximate
          count_of_pension_pots
          value_of_pension_pots
          upper_value_of_pension_pots
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
          covering_letter_type
          has_defined_contribution_pension
          supplementary_benefits
          supplementary_debt
          supplementary_ill_health
          supplementary_defined_benefit_pensions
          supplementary_pension_transfers
          requested_digital
          number_of_previous_appointments
          created_at
          email
          notification_id
        )
      )
    end

    it 'generates correctly mapped rows' do
      expect(subject.last.chomp.split(separator, -1)).to eq(
        [
          appointment.to_param,
          appointment.telephone_appointment.to_s,
          appointment.user.organisation_content_id,
          appointment.date_of_appointment.to_s,
          appointment.value_of_pension_pots_is_approximate.to_s,
          appointment.count_of_pension_pots.to_s,
          appointment.value_of_pension_pots.to_s,
          appointment.upper_value_of_pension_pots.to_s,
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
          appointment.covering_letter_type,
          appointment.has_defined_contribution_pension.to_s,
          appointment.supplementary_benefits.to_s,
          appointment.supplementary_debt.to_s,
          appointment.supplementary_ill_health.to_s,
          appointment.supplementary_defined_benefit_pensions.to_s,
          appointment.supplementary_pension_transfers.to_s,
          appointment.requested_digital.to_s,
          appointment.number_of_previous_appointments.to_s,
          appointment.created_at.getlocal.to_fs(:rfc),
          appointment.email,
          quote_empty_string(appointment.notification_id)
        ]
      )
    end

    def quote_empty_string(value)
      value == '' ? '""' : value
    end
  end
end
