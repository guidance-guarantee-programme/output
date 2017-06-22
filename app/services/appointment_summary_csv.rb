# frozen_string_literal: true
class AppointmentSummaryCsv < CsvGenerator
  def attributes # rubocop:disable Metrics/MethodLength
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
      has_defined_contribution_pension
      supplementary_benefits
      supplementary_debt
      supplementary_ill_health
      supplementary_defined_benefit_pensions
      supplementary_pension_transfers
      continue_working
      unsure
      leave_inheritance
      wants_flexibility
      wants_security
      wants_lump_sum
      poor_health
      requested_digital
      number_of_previous_appointments
      created_at
      email
      notification_id
    ).freeze
  end

  def created_at_formatter(value)
    value.getlocal.to_s(:rfc)
  end
end
