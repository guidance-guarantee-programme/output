class ChangeToDigitalByDefault < ActiveRecord::Migration
  def change
    change_column_default :appointment_summaries, :requested_digital, true
  end
end
