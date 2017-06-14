class AddCountryToAppointmentSummaries < ActiveRecord::Migration[4.2]
  def change
    add_column :appointment_summaries, :country, :string, default: Countries.uk
  end
end
