class AddSupplementarySectionsToAppointmentSummaries < ActiveRecord::Migration
  def change
    add_column :appointment_summaries, :supplementary_benefits, :boolean
    add_column :appointment_summaries, :supplementary_debt, :boolean
    add_column :appointment_summaries, :supplementary_ill_health, :boolean
    add_column :appointment_summaries, :supplementary_defined_benefit_pensions, :boolean
  end
end
