class CreateAppointmentSummaries < ActiveRecord::Migration[4.2]
  def change
    create_table :appointment_summaries do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
