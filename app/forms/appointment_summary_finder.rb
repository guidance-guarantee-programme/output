# frozen_string_literal: true
class AppointmentSummaryFinder
  include ActiveModel::Model

  attr_accessor :search_string, :search_date

  def initialize(search_string:, search_date:)
    @search_string = search_string
    @search_date = search_date
  end

  def results
    return [] if search_string.blank? && search_date.blank?

    scope = AppointmentSummary.order(:date_of_appointment, :created_at)

    scope = scope.where(reference_number: search_string) if search_string
    scope = scope.where(date_of_appointment: parsed_search_date, requested_digital: false) if search_date

    scope
  end

  private

  def parsed_search_date
    Date.strptime(search_date, '%d/%m/%Y')
  rescue ArgumentError => e
    return nil if e.message == 'invalid date'
    raise
  end
end
