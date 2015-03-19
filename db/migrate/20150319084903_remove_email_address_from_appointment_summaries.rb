class RemoveEmailAddressFromAppointmentSummaries < ActiveRecord::Migration
  def change
    remove_column :appointment_summaries, :email_address, :string
  end
end
