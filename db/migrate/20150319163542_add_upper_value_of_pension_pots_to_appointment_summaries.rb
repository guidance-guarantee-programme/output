class AddUpperValueOfPensionPotsToAppointmentSummaries < ActiveRecord::Migration
  def change
    add_column :appointment_summaries, :upper_value_of_pension_pots, :money
  end
end
