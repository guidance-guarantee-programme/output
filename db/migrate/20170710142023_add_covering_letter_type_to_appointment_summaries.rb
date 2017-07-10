class AddCoveringLetterTypeToAppointmentSummaries < ActiveRecord::Migration[5.1]
  def change
    add_column :appointment_summaries, :covering_letter_type, :string, null: false, default: ''
  end
end
