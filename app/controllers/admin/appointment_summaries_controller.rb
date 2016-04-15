module Admin
  class AppointmentSummariesController < ::ApplicationController
    before_action :authenticate_admin!

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

    def authenticate_admin!
      authenticate_user!

      redirect_to :root unless current_user.admin?
    end
  end
end
