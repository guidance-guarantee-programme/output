class AppointmentSummariesController < ApplicationController
  before_action :authenticate_user!

  def new
    @appointment_summary = AppointmentSummary.new(guider_name: current_user.name,
                                                  guider_organisation: current_user.organisation,
                                                  date_of_appointment: DateTime.now)
  end

  def create
    @appointment_summary = AppointmentSummary.create(appointment_summary_params.merge(user: current_user))
    if @appointment_summary.persisted?
      IssueOutputDocument.new(@appointment_summary).call
    else
      render :new
    end
  end

  def show
    appointment_summary = AppointmentSummary.find(params[:id])
    output_document = OutputDocument.new(appointment_summary)

    respond_to do |format|
      format.html { render html: output_document.html.html_safe }
      format.pdf do
        send_data output_document.pdf,
                  filename: 'pension_wise.pdf', type: 'application/pdf',
                  disposition: :inline
      end
    end
  end

  private

  def appointment_summary_params
    params.require(:appointment_summary).permit(:name, :email_address, :address,
                                                :date_of_appointment, :value_of_pension_pots,
                                                :income_in_retirement, :guider_name,
                                                :guider_organisation, :continue_working, :unsure,
                                                :leave_inheritance, :wants_flexibility,
                                                :wants_security, :wants_lump_sum, :poor_health)
  end
end
