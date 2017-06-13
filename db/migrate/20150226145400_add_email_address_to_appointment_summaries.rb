class AddEmailAddressToAppointmentSummaries < ActiveRecord::Migration[4.2]
  def change
    add_column :appointment_summaries, :email_address, :string
  end
end
