class AddValueOfPensionPotsToAppointmentSummaries < ActiveRecord::Migration
  def change
    add_column :appointment_summaries, :value_of_pension_pots, :money
  end
end
