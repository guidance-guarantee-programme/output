class AddValueOfPensionPotsToAppointmentSummaries < ActiveRecord::Migration[4.2]
  def change
    add_column :appointment_summaries, :value_of_pension_pots, :money
  end
end
