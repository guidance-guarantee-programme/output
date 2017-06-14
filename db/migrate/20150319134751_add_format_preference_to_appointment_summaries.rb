class AddFormatPreferenceToAppointmentSummaries < ActiveRecord::Migration[4.2]
  def change
    add_column :appointment_summaries, :format_preference, :string
  end
end
