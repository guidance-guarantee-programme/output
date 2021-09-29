class AddUniqueReferenceNumberToAppointmentSummary < ActiveRecord::Migration[5.1]
  def change
    add_column :appointment_summaries, :unique_reference_number, :string, null: false, default: ''
  end
end
