# frozen_string_literal: true
class OutputDocument
  include ActionView::Helpers::NumberHelper

  attr_accessor :appointment_summary

  delegate :id, :supplementary_benefits,
           :supplementary_debt, :supplementary_ill_health,
           :supplementary_defined_benefit_pensions,
           :format_preference, :appointment_type,
           to: :appointment_summary

  delegate :address_line_1, :address_line_2, :address_line_3, :town, :county, :postcode,
           to: :appointment_summary, prefix: :attendee

  def initialize(appointment_summary)
    @appointment_summary = appointment_summary
  end

  def attendee_name
    "#{appointment_summary.title} #{appointment_summary.first_name} #{appointment_summary.last_name}".squish
  end

  def attendee_country
    Countries.uk?(appointment_summary.country) ? nil : appointment_summary.country
  end

  def attendee_address
    [attendee_name,
     attendee_address_line_1,
     attendee_address_line_2,
     attendee_address_line_3,
     attendee_town,
     attendee_county,
     attendee_postcode,
     attendee_country].reject(&:blank?).map(&:squish).join("\n")
  end

  def appointment_date
    appointment_summary.date_of_appointment.to_s(:gov_uk)
  end

  def guider_organisation
    if appointment_summary.guider_organisation == 'tpas'
      'The Pensions Advisory Service'
    else
      'Pension Wise'
    end
  end

  def variant
    if appointment_summary.eligible_for_guidance?
      appointment_type
    else
      'other'
    end
  end

  def lead
    "You recently had a Pension Wise guidance appointment with #{guider_first_name} " \
      "from #{guider_organisation} on #{appointment_date}."
  end

  def appointment_reference
    "#{appointment_summary.id}/#{appointment_summary.reference_number}"
  end

  def format
    appointment_summary.format_preference
  end

  def guider_first_name
    appointment_summary.guider_name
  end

  def html
    HTMLRenderer.new(self).render
  end

  private

  def to_currency(number)
    return '' if number.blank?

    number_to_currency(number, precision: 0)
  end
end
