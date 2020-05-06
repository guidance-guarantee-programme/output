# frozen_string_literal: true
module Admin
  class AppointmentSummariesController < ::ApplicationController
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
      params
        .fetch(:appointment_summary_browser, {})
        .permit(:start_date, :end_date, :search_string, :requested_digital, :telephone_appointment)
        .merge(page: params[:page])
    end

    def appointment_summary_params
      params.require(:appointment_summary)
            .permit(:email)
            .merge(notification_id: nil)
    end
  end
end
