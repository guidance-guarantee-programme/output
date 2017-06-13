class CreateAppointmentSummariesBatches < ActiveRecord::Migration[4.2]
  def change
    create_table :appointment_summaries_batches do |t|
      t.references :appointment_summary, index: true
      t.references :batch, index: true
    end
    add_foreign_key :appointment_summaries_batches, :appointment_summaries
    add_foreign_key :appointment_summaries_batches, :batches
  end
end
