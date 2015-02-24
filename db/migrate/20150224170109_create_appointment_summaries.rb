class CreateAppointmentSummaries < ActiveRecord::Migration
  def change
    create_table :appointment_summaries do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
