class AddReferenceNumberToAppointmentSummaries < ActiveRecord::Migration[4.2]
  def change
    add_column :appointment_summaries, :reference_number, :integer
  end
end
