class AddNotificationFields < ActiveRecord::Migration[4.2]
  def change
    add_column :appointment_summaries, :email, :string, default: ''
    add_column :appointment_summaries, :notification_id, :string, default: ''
  end
end
