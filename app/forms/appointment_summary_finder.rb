# frozen_string_literal: true
class AppointmentSummaryFinder
  include ActiveModel::Model

  attr_accessor :search_string

  def initialize(search_string:)
    @search_string = search_string
  end

  def results
    return [] if search_string.blank?

    AppointmentSummary
      .where(reference_number: search_string)
      .order(:date_of_appointment, :created_at)
  end
end
