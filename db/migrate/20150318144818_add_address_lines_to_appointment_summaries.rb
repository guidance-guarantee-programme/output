class AddAddressLinesToAppointmentSummaries < ActiveRecord::Migration
  def change
    add_column :appointment_summaries, :address_line_1, :string
    add_column :appointment_summaries, :address_line_2, :string
    add_column :appointment_summaries, :address_line_3, :string
    add_column :appointment_summaries, :town, :string
    add_column :appointment_summaries, :county, :string
    add_column :appointment_summaries, :postcode, :string
  end
end
