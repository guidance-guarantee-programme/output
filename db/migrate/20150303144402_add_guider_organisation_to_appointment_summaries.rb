class AddGuiderOrganisationToAppointmentSummaries < ActiveRecord::Migration[4.2]
  def change
    add_column :appointment_summaries, :guider_organisation, :string
  end
end
