class RemoveNameAndAddressFromAppointmentSummaries < ActiveRecord::Migration[4.2]
  def change
    remove_column :appointment_summaries, :name, :string
    remove_column :appointment_summaries, :address, :string
  end
end
