# frozen_string_literal: true
class AppointmentSummaryBrowser
  include ActiveModel::Model

  attr_accessor :start_date, :end_date, :search_string, :page
  attr_accessor :telephone_appointment, :requested_digital

  def results
    text_filter(
      date_filter(
        telephone_filter(
          requested_digital_filter(
            AppointmentSummary.order(date_of_appointment: :desc)
          )
        )
      )
    )
  end

  def paginated_results
    results.page(page)
  end

  def start_date
    normalise_date(@start_date, 1.month.ago.to_date)
  end

  def end_date
    normalise_date(@end_date, Time.zone.today)
  end

  private

  def normalise_date(date, default)
    date.present? ? Time.zone.parse(date) : default
  end

  def telephone_filter(scope)
    return scope if telephone_appointment.blank?

    scope.where(telephone_appointment: telephone_appointment == 'true')
  end

  def requested_digital_filter(scope)
    return scope if requested_digital.blank?

    scope.where(requested_digital: requested_digital == 'true')
  end

  def date_filter(scope)
    scope.where(date_of_appointment: start_date..end_date)
  end

  def text_filter(scope)
    return scope if @search_string.blank?

    scope.where(
      'appointment_summaries.last_name ilike ? OR appointment_summaries.reference_number = ?',
      "%#{@search_string}%",
      @search_string
    )
  end
end
