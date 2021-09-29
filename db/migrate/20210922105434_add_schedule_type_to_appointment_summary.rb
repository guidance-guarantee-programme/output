class AddScheduleTypeToAppointmentSummary < ActiveRecord::Migration[5.1]
  def change
    add_column :appointment_summaries, :schedule_type, :string, null: false, default: 'pension_wise'
  end
end
