class AppointmentSummariesController < ApplicationController
  def new
    @appointment_summary = AppointmentSummary.new
  end

  def create
    @appointment_summary = AppointmentSummary.create(appointment_summary_params)
    if @appointment_summary.persisted?
      redirect_to new_appointment_summary_path, notice: 'The appointment summary was saved'
    else
      render :new
    end
  end

  private

  def appointment_summary_params
    params.require(:appointment_summary).permit(:name, :email_address)
  end
end
