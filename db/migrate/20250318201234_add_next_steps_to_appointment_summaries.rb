class AddNextStepsToAppointmentSummaries < ActiveRecord::Migration[6.1]
  def change
    add_column :appointment_summaries, :updated_beneficiaries, :string, null: false, default: ''
    add_column :appointment_summaries, :regulated_financial_advice, :string, null: false, default: ''
    add_column :appointment_summaries, :kept_track_of_all_pensions, :string, null: false, default: ''
    add_column :appointment_summaries, :interested_in_pension_transfer, :string, null: false, default: ''
    add_column :appointment_summaries, :created_retirement_budget, :string, null: false, default: ''
    add_column :appointment_summaries, :know_how_much_state_pension, :string, null: false, default: ''
    add_column :appointment_summaries, :received_state_benefits, :string, null: false, default: ''
    add_column :appointment_summaries, :pension_to_pay_off_debts, :string, null: false, default: ''
    add_column :appointment_summaries, :living_or_planning_overseas, :string, null: false, default: ''
    add_column :appointment_summaries, :finalised_a_will, :string, null: false, default: ''
    add_column :appointment_summaries, :setup_power_of_attorney, :string, null: false, default: ''
  end
end
