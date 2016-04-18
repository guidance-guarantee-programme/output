class AppointmentSummaryBrowser
  include ActiveModel::Model

  attr_accessor :start_date, :end_date, :page

  def initialize(page:, start_date:, end_date:)
    @page       = page
    @start_date = normalise_date(start_date, 1.month.ago.to_date)
    @end_date   = normalise_date(end_date, Time.zone.today)
  end

  def results
    AppointmentSummary
      .includes(:user)
      .order(date_of_appointment: :desc)
      .where(date_of_appointment: start_date..end_date)
  end

  def paginated_results
    results.page(page)
  end

  private

  def normalise_date(date, default)
    date.present? ? Time.zone.parse(date) : default
  end
end
