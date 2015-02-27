class AppointmentSummariesController < ApplicationController
  def new
    @appointment_summary = AppointmentSummary.new
  end

  def create
    @appointment_summary = AppointmentSummary.create(appointment_summary_params)
    if @appointment_summary.persisted?
      redirect_to appointment_summary_path(@appointment_summary, format: :pdf)
    else
      render :new
    end
  end

  def show
    @appointment_summary = AppointmentSummary.find(params[:id])
    OutputDocumentMailer.guidance_record(@appointment_summary).deliver_later

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: 'pension_wise', encoding: 'utf-8',
               template: 'appointment_summaries/show.html.erb'
      end
    end
  end

  private

  def appointment_summary_params
    params.require(:appointment_summary).permit(:name, :email_address)
  end
end
