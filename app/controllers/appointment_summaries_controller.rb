# frozen_string_literal: true
class AppointmentSummariesController < ApplicationController
  before_action :authenticate_user!

  def new
    prepopulated_fields = { guider_name: current_user.first_name,
                            guider_organisation: current_user.organisation,
                            date_of_appointment: Time.zone.today }

    prepopulated_fields.merge!(appointment_summary_params) if params.include?(:appointment_summary)

    @appointment_summary = AppointmentSummary.new(prepopulated_fields)
  end

  def preview
    @appointment_summary = AppointmentSummary.new(appointment_summary_params)
    if @appointment_summary.valid?
      @output_document = OutputDocument.new(@appointment_summary)
    else
      render :email_confirmation
    end
  end

  def email_confirmation
    @appointment_summary = AppointmentSummary.new(appointment_summary_params)
    render :new unless @appointment_summary.valid?
  end

  def create
    @appointment_summary = AppointmentSummary.create(appointment_summary_params.merge(user: current_user))
    if @appointment_summary.persisted?
      NotifyViaEmail.perform_later(@appointment_summary) if @appointment_summary.can_be_emailed?
      render :create
    else
      render :new
    end
  end

  def show
    appointment_summary = AppointmentSummary.find(params[:id])
    output_document = OutputDocument.new(appointment_summary)

    render html: output_document.html.html_safe
  end

  private

  def appointment_summary_params
    params.require(:appointment_summary).permit(AppointmentSummary.editable_column_names)
  end
end
