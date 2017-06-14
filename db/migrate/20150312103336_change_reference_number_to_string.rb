class ChangeReferenceNumberToString < ActiveRecord::Migration[4.2]
  def change
    change_column :appointment_summaries, :reference_number, :string
  end
end
