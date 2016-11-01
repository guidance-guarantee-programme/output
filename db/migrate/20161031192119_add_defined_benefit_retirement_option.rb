class AddDefinedBenefitRetirementOption < ActiveRecord::Migration
  def change
    add_column :appointment_summaries, :retirement_income_defined_benefit, :boolean, default: false, null: false
  end
end
