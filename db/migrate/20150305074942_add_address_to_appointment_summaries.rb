class AddAddressToAppointmentSummaries < ActiveRecord::Migration
  def change
    add_column :appointment_summaries, :address, :text
  end
end
