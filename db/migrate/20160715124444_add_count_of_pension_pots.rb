class AddCountOfPensionPots < ActiveRecord::Migration[4.2]
  def change
    add_column :appointment_summaries, :count_of_pension_pots, :integer
  end
end
