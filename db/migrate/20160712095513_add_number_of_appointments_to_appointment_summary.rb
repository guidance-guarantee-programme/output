class AddNumberOfAppointmentsToAppointmentSummary < ActiveRecord::Migration
  def change
    add_column :appointment_summaries, :number_of_appointments, :string, null: false, default: ''
  end
end
