class RemoveNameAndAddressFromAppointmentSummaries < ActiveRecord::Migration
  def change
    remove_column :appointment_summaries, :name, :string
    remove_column :appointment_summaries, :address, :string
  end
end
