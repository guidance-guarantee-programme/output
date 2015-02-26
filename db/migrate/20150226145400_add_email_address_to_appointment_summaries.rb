class AddEmailAddressToAppointmentSummaries < ActiveRecord::Migration
  def change
    add_column :appointment_summaries, :email_address, :string
  end
end
