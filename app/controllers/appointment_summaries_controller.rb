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
    params.require(:appointment_summary).permit(:title, :first_name, :last_name, :email_address,
                                                :address_line_1, :address_line_2, :address_line_3,
                                                :town, :county, :postcode, :date_of_appointment,
                                                :reference_number, :value_of_pension_pots,
                                                :income_in_retirement, :guider_name,
                                                :guider_organisation, :continue_working, :unsure,
                                                :leave_inheritance, :wants_flexibility,
                                                :wants_security, :wants_lump_sum, :poor_health)
  end
end
