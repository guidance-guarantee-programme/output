module Admin
  class AppointmentSummariesController < ::ApplicationController
    def index
      @appointment_form = AppointmentSummaryBrowser.new(form_params)
    end

    private

    def form_params
      {
        page:       params[:page],
        start_date: params.dig(:appointment_summary_browser, :start_date),
        end_date:   params.dig(:appointment_summary_browser, :end_date)
      }
    end
  end
end
