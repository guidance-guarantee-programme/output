class AddDateOfAppointmentToAppointmentSummaries < ActiveRecord::Migration
  def change
    add_column :appointment_summaries, :date_of_appointment, :date
  end
end
