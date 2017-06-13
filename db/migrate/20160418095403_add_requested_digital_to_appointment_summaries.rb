class AddRequestedDigitalToAppointmentSummaries < ActiveRecord::Migration[4.2]
  def change
    add_column :appointment_summaries, :requested_digital, :boolean, null: false, default: false
  end
end
