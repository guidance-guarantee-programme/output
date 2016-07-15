class AddCountOfPensionPots < ActiveRecord::Migration
  def change
    add_column :appointment_summaries, :count_of_pension_pots, :integer
  end
end
