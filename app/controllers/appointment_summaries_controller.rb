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
      render :new
    end
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
    params.require(:appointment_summary).permit(:title, :first_name, :last_name,
                                                :address_line_1, :address_line_2, :address_line_3,
                                                :town, :county, :postcode, :country, :date_of_appointment,
                                                :reference_number, :value_of_pension_pots,
                                                :upper_value_of_pension_pots, :value_of_pension_pots_is_approximate,
                                                :income_in_retirement, :guider_name,
                                                :guider_organisation, :continue_working, :unsure,
                                                :leave_inheritance, :wants_flexibility,
                                                :wants_security, :wants_lump_sum, :poor_health,
                                                :has_defined_contribution_pension,
                                                :format_preference, :supplementary_benefits,
                                                :supplementary_debt, :supplementary_ill_health,
                                                :supplementary_defined_benefit_pensions,
                                                :appointment_type)
  end
end
