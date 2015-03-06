class ChangeAppointmentSummariesValueOfPensionPotsToString < ActiveRecord::Migration
  def change
    change_column :appointment_summaries, :value_of_pension_pots, :string
  end
end
