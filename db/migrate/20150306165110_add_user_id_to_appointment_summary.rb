class AddUserIdToAppointmentSummary < ActiveRecord::Migration
  def change
    add_column :appointment_summaries, :user_id, :integer

    add_index :appointment_summaries, :user_id
  end
end
