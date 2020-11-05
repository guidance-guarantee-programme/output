class AddDbPotAttributesToAppointmentSummaries < ActiveRecord::Migration[5.1]
  def change
    add_column :appointment_summaries, :has_defined_benefit_pension, :string
    add_column :appointment_summaries, :considering_transferring_to_dc_pot, :string
  end
end
