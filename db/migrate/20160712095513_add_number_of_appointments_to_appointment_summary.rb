class AddNumberOfAppointmentsToAppointmentSummary < ActiveRecord::Migration
  def change
    add_column :appointment_summaries, :number_of_previous_appointments, :integer, null: false, default: 0
  end
end
