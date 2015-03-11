class AddReferenceNumberToAppointmentSummaries < ActiveRecord::Migration
  def change
    add_column :appointment_summaries, :reference_number, :integer
  end
end
