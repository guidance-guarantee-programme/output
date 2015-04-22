class AddCountryToAppointmentSummaries < ActiveRecord::Migration
  def change
    add_column :appointment_summaries, :country, :string
  end
end
