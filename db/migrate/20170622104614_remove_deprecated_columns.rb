class RemoveDeprecatedColumns < ActiveRecord::Migration[5.1]
  def up
    remove_column :appointment_summaries, :income_in_retirement
    remove_column :appointment_summaries, :guider_organisation
    remove_column :appointment_summaries, :retirement_income_other_state_benefits
    remove_column :appointment_summaries, :retirement_income_defined_benefit
    remove_column :appointment_summaries, :retirement_income_employment
    remove_column :appointment_summaries, :retirement_income_partner
    remove_column :appointment_summaries, :retirement_income_interest_or_savings
    remove_column :appointment_summaries, :retirement_income_property
    remove_column :appointment_summaries, :retirement_income_business
    remove_column :appointment_summaries, :retirement_income_inheritance
    remove_column :appointment_summaries, :retirement_income_other_income
    remove_column :appointment_summaries, :retirement_income_unspecified
    remove_column :appointment_summaries, :continue_working
    remove_column :appointment_summaries, :unsure
    remove_column :appointment_summaries, :leave_inheritance
    remove_column :appointment_summaries, :wants_flexibility
    remove_column :appointment_summaries, :wants_security
    remove_column :appointment_summaries, :wants_lump_sum
    remove_column :appointment_summaries, :poor_health
  end

  def down
    # noop
  end
end
