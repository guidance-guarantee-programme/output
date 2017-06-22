# frozen_string_literal: true
require_relative '../site_prism/radio_button_container'

# rubocop:disable ClassLength
class AppointmentSummaryPage < SitePrism::Page
  extend SitePrism::RadioButtonContainer
  set_url '/appointment_summaries/new{?params*}'
  set_url_matcher %r{/appointment_summaries/new}

  element :use_tap_warning, '.t-use-tap'

  element :title, '.t-title'
  element :first_name, '.t-first-name'
  element :last_name, '.t-last-name'
  element :address_line_1, '.t-address-line-1'
  element :address_line_2, '.t-address-line-2'
  element :address_line_3, '.t-address-line-3'
  element :town, '.t-town'
  element :county, '.t-county'
  element :country, '.t-country'
  element :postcode, '.t-postcode'
  element :date_of_appointment, '.t-date-of-appointment'
  element :reference_number, '.t-reference-number'
  element :value_of_pension_pots, '.t-value-of-pension-pots'
  element :upper_value_of_pension_pots, '.t-upper-value-of-pension-pots'
  element :value_of_pension_pots_is_approximate, '.t-value-of-pension-pots-is-approximate'
  element :count_of_pension_pots, '.t-count-of-pension-pots'

  element :guider_name, '.t-guider-name'
  radio_buttons :has_defined_contribution_pension, yes: '.t-has-defined-contribution-pension-yes',
                                                   no: '.t-has-defined-contribution-pension-no',
                                                   unknown: '.t-has-defined-contribution-pension-unknown'

  radio_buttons :format_preference, standard: '.t-format-preference-standard',
                                    large_text: '.t-format-preference-large-text',
                                    braille: '.t-format-preference-braille'

  radio_buttons :appointment_type, standard: '.t-appointment-type-standard',
                                   appointment_50_54: '.t-appointment-type-50-54'
  radio_buttons :first_appointment, yes: '.t-first-appointment-yes',
                                    no: '.t-first-appointment-no'
  radio_buttons :number_of_previous_appointments, zero: '.t-number-of-previous-appointments-0',
                                                  one: '.t-number-of-previous-appointments-1',
                                                  two: '.t-number-of-previous-appointments-2',
                                                  three: '.t-number-of-previous-appointments-3'
  radio_buttons :requested_digital, true: '.t-requested-digital',
                                    false: '.t-requested-postal'

  element :email, '.t-email'
  element :email_suggestion, '.t-email-suggestion'
  element :supplementary_benefits, '.t-supplementary-benefits'
  element :supplementary_debt, '.t-supplementary-debt'
  element :supplementary_ill_health, '.t-supplementary-ill-health'
  element :supplementary_defined_benefit_pensions, '.t-supplementary-defined-benefit-pensions'
  element :supplementary_pension_transfers, '.t-supplementary-pension-transfers'

  element :submit, '.t-submit'

  def load(appointment_summary = nil)
    if appointment_summary
      super(params: params(appointment_summary))
    else
      super()
    end
  end

  def params(appointment_summary)
    params_from_tap = %i(
      appointment_type
      date_of_appointment
      email
      first_name
      last_name
      guider_name
      number_of_previous_appointments
      reference_number
    )

    {}.tap do |params|
      params_from_tap.each do |param|
        params["appointment_summary[#{param}]"] = appointment_summary[param]
      end
    end
  end

  def fill_in(appointment_summary, face_to_face: false)
    fill_in_customer_details(appointment_summary)
    fill_in_pension_pot_details(appointment_summary)
    fill_in_has_defined_contribution_pension(appointment_summary)
    fill_in_format_preference(appointment_summary)
    fill_in_digital_request(appointment_summary)
    fill_in_supplementary_information(appointment_summary)
    fill_in_face_to_face_only_details(appointment_summary) if face_to_face
  end

  private

  def fill_in_customer_details(appointment_summary)
    title.select appointment_summary.title
    address_line_1.set appointment_summary.address_line_1
    address_line_2.set appointment_summary.address_line_2
    address_line_3.set appointment_summary.address_line_3
    town.set appointment_summary.town
    county.set appointment_summary.county
    country.select appointment_summary.country
    postcode.set appointment_summary.postcode
  end

  def fill_in_pension_pot_details(appointment_summary)
    value_of_pension_pots.set appointment_summary.value_of_pension_pots
    upper_value_of_pension_pots.set appointment_summary.upper_value_of_pension_pots
    value_of_pension_pots_is_approximate.set appointment_summary.value_of_pension_pots_is_approximate?
    count_of_pension_pots.set appointment_summary.count_of_pension_pots
  end

  def fill_in_has_defined_contribution_pension(appointment_summary)
    case appointment_summary.has_defined_contribution_pension
    when 'yes' then has_defined_contribution_pension_yes.set true
    when 'no' then has_defined_contribution_pension_no.set true
    when 'unknown' then has_defined_contribution_pension_unknown.set true
    end
  end

  def fill_in_format_preference(appointment_summary)
    case appointment_summary.format_preference
    when 'standard' then format_preference_standard.set true
    when 'large_text' then format_preference_large_text.set true
    when 'braille' then format_preference_braille.set true
    end
  end

  def fill_in_digital_request(appointment_summary)
    if appointment_summary.requested_digital
      requested_digital_true.set true
    else
      requested_digital_false.set true
    end
  end

  def fill_in_supplementary_information(appointment_summary)
    supplementary_benefits.set appointment_summary.supplementary_benefits
    supplementary_debt.set appointment_summary.supplementary_debt
    supplementary_ill_health.set appointment_summary.supplementary_ill_health
    supplementary_defined_benefit_pensions.set appointment_summary.supplementary_defined_benefit_pensions
    supplementary_pension_transfers.set appointment_summary.supplementary_pension_transfers
  end

  def fill_in_face_to_face_only_details(appointment_summary)
    first_name.set appointment_summary.first_name
    last_name.set appointment_summary.last_name
    email.set appointment_summary.email
    reference_number.set appointment_summary.reference_number
    guider_name.set appointment_summary.guider_name
    date_of_appointment.set appointment_summary.date_of_appointment
    fill_in_format_preference(appointment_summary)
  end

  def fill_in_appointment_type(appointment_summary)
    case appointment_summary.appointment_type
    when 'standard' then appointment_type_standard.set true
    when 'appointment_50_54' then appointment_type_appointment_50_54.set true
    end
  end
end
# rubocop:enable ClassLength
