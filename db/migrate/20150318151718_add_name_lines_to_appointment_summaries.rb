class AddNameLinesToAppointmentSummaries < ActiveRecord::Migration[4.2]
  def change
    add_column :appointment_summaries, :title, :string
    add_column :appointment_summaries, :first_name, :string
    add_column :appointment_summaries, :last_name, :string

    change_column_null :appointment_summaries, :name, true
  end
end
