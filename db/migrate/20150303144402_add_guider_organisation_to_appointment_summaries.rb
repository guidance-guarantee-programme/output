class AddGuiderOrganisationToAppointmentSummaries < ActiveRecord::Migration
  def change
    add_column :appointment_summaries, :guider_organisation, :string
  end
end
