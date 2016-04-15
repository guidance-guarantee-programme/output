require 'csv'

class AppointmentSummaryCsv
  ATTRIBUTES = %w(
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

  def initialize(appointments)
    @appointments = Array(appointments)
  end

  def call
    CSV.generate do |output|
      output << ATTRIBUTES

      appointments.each { |appointment| output << row(appointment) }
    end
  end
  alias_method :csv, :call

  private

  attr_reader :appointments

  def row(appointment)
    appointment
      .attributes
      .slice(*ATTRIBUTES)
      .values
      .map(&:to_s)
  end
end
