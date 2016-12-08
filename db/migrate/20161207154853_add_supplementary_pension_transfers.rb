class AddSupplementaryPensionTransfers < ActiveRecord::Migration
  def change
    add_column :appointment_summaries, :supplementary_pension_transfers, :boolean, default: false
  end
end
