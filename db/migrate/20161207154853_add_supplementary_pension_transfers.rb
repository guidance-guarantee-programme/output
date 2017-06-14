class AddSupplementaryPensionTransfers < ActiveRecord::Migration[4.2]
  def change
    add_column :appointment_summaries, :supplementary_pension_transfers, :boolean, default: false
  end
end
