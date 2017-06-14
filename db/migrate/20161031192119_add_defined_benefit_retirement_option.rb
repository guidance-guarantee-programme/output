class AddDefinedBenefitRetirementOption < ActiveRecord::Migration[4.2]
  def change
    add_column :appointment_summaries, :retirement_income_defined_benefit, :boolean, default: false, null: false
  end
end
