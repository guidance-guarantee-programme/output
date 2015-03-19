class AddHasDefinedContributionPensionToAppointmentSummaries < ActiveRecord::Migration
  def change
    add_column :appointment_summaries, :has_defined_contribution_pension, :string
  end
end
