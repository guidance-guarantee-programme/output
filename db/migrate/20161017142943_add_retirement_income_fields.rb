class AddRetirementIncomeFields < ActiveRecord::Migration[4.2]
  def change
    add_column :appointment_summaries, :retirement_income_other_state_benefits, :boolean, default: false, null: false
    add_column :appointment_summaries, :retirement_income_employment, :boolean, default: false, null: false
    add_column :appointment_summaries, :retirement_income_partner, :boolean, default: false, null: false
    add_column :appointment_summaries, :retirement_income_interest_or_savings, :boolean, default: false, null: false
    add_column :appointment_summaries, :retirement_income_property, :boolean, default: false, null: false
    add_column :appointment_summaries, :retirement_income_business, :boolean, default: false, null: false
    add_column :appointment_summaries, :retirement_income_inheritance, :boolean, default: false, null: false
    add_column :appointment_summaries, :retirement_income_other_income, :boolean, default: false, null: false
    add_column :appointment_summaries, :retirement_income_unspecified, :boolean, default: false, null: false
  end
end
