class ChangeReferenceNumberToString < ActiveRecord::Migration
  def change
    change_column :appointment_summaries, :reference_number, :string
  end
end
