class AddApointmentTypeToAppointmentSummaries < ActiveRecord::Migration
  def change
    add_column :appointment_summaries, :appointment_type, :string
  end
end
