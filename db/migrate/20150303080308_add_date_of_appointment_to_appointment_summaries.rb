class AddDateOfAppointmentToAppointmentSummaries < ActiveRecord::Migration[4.2]
  def change
    add_column :appointment_summaries, :date_of_appointment, :date
  end
end
