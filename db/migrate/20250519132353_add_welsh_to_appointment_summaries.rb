class AddWelshToAppointmentSummaries < ActiveRecord::Migration[8.0]
  def change
    add_column :appointment_summaries, :welsh, :boolean, default: false, null: false
  end
end
