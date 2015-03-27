class AddValueOfPensionPotsIsApproximateToAppointmentSummary < ActiveRecord::Migration
  def change
    add_column :appointment_summaries, :value_of_pension_pots_is_approximate, :boolean
  end
end
