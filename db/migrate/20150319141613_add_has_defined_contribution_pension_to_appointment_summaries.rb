class AddHasDefinedContributionPensionToAppointmentSummaries < ActiveRecord::Migration[4.2]
  def change
    add_column :appointment_summaries, :has_defined_contribution_pension, :string
  end
end
