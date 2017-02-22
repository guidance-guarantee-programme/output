class AddNotifyDeliveryToAppointmentSummaries < ActiveRecord::Migration[5.0]
  def change
    add_column :appointment_summaries, :notify_completed_at, :datetime, null: true
    add_column :appointment_summaries, :notify_status, :integer, null: false, default: 0
  end
end
