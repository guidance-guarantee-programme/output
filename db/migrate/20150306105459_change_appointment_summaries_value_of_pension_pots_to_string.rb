class ChangeAppointmentSummariesValueOfPensionPotsToString < ActiveRecord::Migration[4.2]
  def change
    change_column :appointment_summaries, :value_of_pension_pots, :string
  end
end
