class OutputDocument
  include ActionView::Helpers::NumberHelper

  attr_accessor :appointment_summary

  delegate :id, :guider_name, :income_in_retirement, :continue_working, :unsure,
           :leave_inheritance, :wants_flexibility, :wants_security,
           :wants_lump_sum, :poor_health,
           to: :appointment_summary

  delegate :address_line_1, :address_line_2, :address_line_3, :town, :county,
           :postcode,
           to: :appointment_summary, prefix: :attendee

  def initialize(appointment_summary)
    @appointment_summary = appointment_summary
  end

  def attendee_name
    "#{appointment_summary.title} #{appointment_summary.first_name} #{appointment_summary.last_name}".squish
  end

  def appointment_date
    appointment_summary.date_of_appointment.to_s(:long)
  end

  def guider_organisation
    if appointment_summary.guider_organisation == 'tpas'
      'The Pensions Advisory Service'
    else
      'Pension Wise'
    end
  end

  def value_of_pension_pots
    return 'No value given' if appointment_summary.value_of_pension_pots.blank?

    pension_pot = number_to_currency(appointment_summary.value_of_pension_pots, precision: 0)

    unless appointment_summary.upper_value_of_pension_pots.blank?
      upper_limit = number_to_currency(
        appointment_summary.upper_value_of_pension_pots, precision: 0)
      return "#{pension_pot} to #{upper_limit}"
    end

    if appointment_summary.value_of_pension_pots_is_approximate?
      "#{pension_pot} (approximately)"
    else
      pension_pot
    end
  end

  def variant
    if appointment_summary.eligible_for_guidance?
      if appointment_summary.custom_guidance?
        'tailored'
      else
        'generic'
      end
    else
      'other'
    end
  end

  def greeting
  end

  def appointment_reference
    appointment_summary.reference_number
  end

  def pages_to_render
    case variant
    when 'tailored'
      circumstances = %i(continue_working unsure leave_inheritance
                         wants_flexibility wants_security wants_lump_sum
                         poor_health).select do |c|
        appointment_summary.public_send("#{c}?".to_sym)
      end

      [:introduction, circumstances, :other_information].flatten
    when 'generic'
      %w(introduction generic_guidance other_information)
    when 'other'
      %w(ineligible)
    end
  end

  def html
    ERB.new(template).result(binding)
  end

  def csv
    'c,s,v'
  end

  private

  def template
    [:header, pages_to_render, :footer].flatten.reduce('') do |result, section|
      result << template_for(section) << "\n\n"
    end
  end

  def template_for(section)
    File.read(
      Rails.root.join('app', 'templates', "output_document_#{section}.html.erb"))
  end
end
