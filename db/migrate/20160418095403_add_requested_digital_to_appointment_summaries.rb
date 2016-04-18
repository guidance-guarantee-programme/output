class AddRequestedDigitalToAppointmentSummaries < ActiveRecord::Migration
  def change
    add_column :appointment_summaries, :requested_digital, :boolean, null: false, default: false
  end
end
