# frozen_string_literal: true
module Admin
  class AppointmentSummariesController < ::ApplicationController
    before_action :require_signin_permission! # this can't be in ApplicationController due to Gaffe gem
    before_action :authenticate_as_analyst!

    def index
      @appointment_form = AppointmentSummaryBrowser.new(form_params)

      respond_to do |format|
        format.html
        format.csv { render csv: AppointmentSummaryCsv.new(@appointment_form.results) }
      end
    end

    def edit
      @appointment_summary = AppointmentSummary.find(params[:id])
    end

    def update
      @appointment_summary = AppointmentSummary.find(params[:id])

      if @appointment_summary.update(appointment_summary_params)
        NotifyViaEmail.perform_later(@appointment_summary) if @appointment_summary.can_be_emailed?
        redirect_to admin_appointment_summaries_path
      else
        render :edit
      end
    end

    private

    def form_params
      {
        page:          params[:page],
        start_date:    params.dig(:appointment_summary_browser, :start_date),
        end_date:      params.dig(:appointment_summary_browser, :end_date),
        search_string: params.dig(:appointment_summary_browser, :search_string)
      }
    end

    def appointment_summary_params
      params.require(:appointment_summary)
            .permit(:email)
            .merge(notification_id: nil)
    end
  end
end
