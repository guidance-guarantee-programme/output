class AddApointmentTypeToAppointmentSummaries < ActiveRecord::Migration[4.2]
  def change
    add_column :appointment_summaries, :appointment_type, :string
  end
end
