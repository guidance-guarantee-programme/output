class AddGuiderNameToAppointmentSummaries < ActiveRecord::Migration[4.2]
  def change
    add_column :appointment_summaries, :guider_name, :string
  end
end
