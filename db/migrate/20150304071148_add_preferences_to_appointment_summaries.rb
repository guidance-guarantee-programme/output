class AddPreferencesToAppointmentSummaries < ActiveRecord::Migration
  def change
    add_column :appointment_summaries, :continue_working, :boolean
    add_column :appointment_summaries, :unsure, :boolean
    add_column :appointment_summaries, :leave_inheritance, :boolean
    add_column :appointment_summaries, :wants_flexibility, :boolean
    add_column :appointment_summaries, :wants_security, :boolean
    add_column :appointment_summaries, :wants_lump_sum, :boolean
    add_column :appointment_summaries, :poor_health, :boolean
  end
end
