class RemoveEmailAddressFromAppointmentSummaries < ActiveRecord::Migration[4.2]
  def change
    remove_column :appointment_summaries, :email_address, :string
  end
end
