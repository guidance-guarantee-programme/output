class ChangeToDigitalByDefault < ActiveRecord::Migration[4.2]
  def change
    change_column_default :appointment_summaries, :requested_digital, true
  end
end
