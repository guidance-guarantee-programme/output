class AddFormatPreferenceToAppointmentSummaries < ActiveRecord::Migration
  def change
    add_column :appointment_summaries, :format_preference, :string
  end
end
