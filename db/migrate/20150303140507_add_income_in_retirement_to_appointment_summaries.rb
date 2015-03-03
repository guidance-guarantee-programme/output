class AddIncomeInRetirementToAppointmentSummaries < ActiveRecord::Migration
  def change
    add_column :appointment_summaries, :income_in_retirement, :string
  end
end
