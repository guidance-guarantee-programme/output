class AddTelephoneAppointmentFlagToAppointmentSummaries < ActiveRecord::Migration[5.0]
  def change
    add_column :appointment_summaries, :telephone_appointment, :boolean, default: true
  end
end
