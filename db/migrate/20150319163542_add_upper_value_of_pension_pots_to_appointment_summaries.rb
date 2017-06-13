class AddUpperValueOfPensionPotsToAppointmentSummaries < ActiveRecord::Migration[4.2]
  def change
    add_column :appointment_summaries, :upper_value_of_pension_pots, :money
  end
end
