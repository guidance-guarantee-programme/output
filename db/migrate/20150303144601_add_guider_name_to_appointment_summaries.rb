class AddGuiderNameToAppointmentSummaries < ActiveRecord::Migration
  def change
    add_column :appointment_summaries, :guider_name, :string
  end
end
