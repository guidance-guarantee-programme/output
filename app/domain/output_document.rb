# frozen_string_literal: true
class OutputDocument
  include ActionView::Helpers::NumberHelper

  attr_accessor :appointment_summary

  delegate :id, :supplementary_benefits,
           :supplementary_debt, :supplementary_ill_health,
           :supplementary_defined_benefit_pensions,
           :supplementary_pension_transfers,
           :format_preference, :appointment_type,
           :unique_reference_number, :schedule_type, :reference_number,
           :welsh?,
           to: :appointment_summary

  delegate :address_line_1, :address_line_2, :address_line_3, :town, :county, :postcode,
           to: :appointment_summary, prefix: :attendee

  delegate :covering_letter_type, to: :appointment_summary

  delegate :updated_beneficiaries?, :regulated_financial_advice?, :kept_track_of_all_pensions?,
           :interested_in_pension_transfer?, :created_retirement_budget?, :know_how_much_state_pension?,
           :received_state_benefits?, :pension_to_pay_off_debts?, :living_or_planning_overseas?,
           :finalised_a_will?, :setup_power_of_attorney?, to: :next_steps

  def initialize(appointment_summary)
    @appointment_summary = appointment_summary
  end

  def attendee_name
    if appointment_summary.title.present?
      "#{appointment_summary.title} #{appointment_summary.last_name}".squish
    else
      appointment_summary.first_name
    end
  end

  def attendee_full_name
    "#{appointment_summary.title} #{appointment_summary.first_name} #{appointment_summary.last_name}".squish
  end

  def attendee_country
    Countries.uk?(appointment_summary.country) ? nil : appointment_summary.country.upcase
  end

  def attendee_address
    [attendee_full_name,
     attendee_address_line_1,
     attendee_address_line_2,
     attendee_address_line_3,
     attendee_town,
     attendee_county,
     attendee_postcode,
     attendee_country].reject(&:blank?).map(&:squish).join("\n")
  end

  def appointment_date
    appointment_summary.date_of_appointment.to_fs(:gov_uk)
  end

  def variant
    return appointment_summary.schedule_type if appointment_summary.due_diligence?

    if appointment_summary.eligible_for_guidance?
      appointment_type
    else
      'other'
    end
  end

  def envelope_class
    'l-envelope--tpas'
  end

  def lead
    if appointment_summary.welsh?
      @appointment_date = I18n.l(
        appointment_summary.date_of_appointment,
        locale: :cy,
        format: Date::DATE_FORMATS[:gov_uk]
      )

      "Yn ddiweddar, cawsoch apwyntiad arweiniad Pension Wise gyda #{guider_first_name} ar #{@appointment_date}."
    else
      "You recently had a Pension Wise guidance appointment with #{guider_first_name} on #{appointment_date}."
    end
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

  def next_steps?
    next_steps.to_h.values.any? { |v| v == 'yes' }
  end

  def html
    HtmlRenderer.new(self).render
  end

  def pdf
    Princely::Pdf.new.pdf_from_string(html)
  end

  private

  def next_steps
    SummaryDocumentNextStepsPresenter.new(appointment_summary)
  end

  def to_currency(number)
    return '' if number.blank?

    number_to_currency(number, precision: 0)
  end
end
