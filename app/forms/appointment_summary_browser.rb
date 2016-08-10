# frozen_string_literal: true
class AppointmentSummaryBrowser
  include ActiveModel::Model

  attr_accessor :start_date, :end_date, :search_string, :page

  def initialize(page:, start_date:, end_date:, search_string:)
    @page          = page
    @start_date    = normalise_date(start_date, 1.month.ago.to_date)
    @end_date      = normalise_date(end_date, Time.zone.today)
    @search_string = search_string
  end

  def results
    text_filter(
      date_filter(
        AppointmentSummary
          .includes(:user)
          .order(date_of_appointment: :desc)
      )
    )
  end

  def paginated_results
    results.page(page)
  end

  private

  def normalise_date(date, default)
    date.present? ? Time.zone.parse(date) : default
  end

  def date_filter(scope)
    scope.where(date_of_appointment: start_date..end_date)
  end

  def text_filter(scope)
    return scope unless @search_string.present?

    scope.where(
      %(appointment_summaries.last_name ilike ? OR appointment_summaries.reference_number = ?),
      "%#{@search_string}%",
      @search_string
    )
  end
end
