class RemoveProcessedAtFromBatches < ActiveRecord::Migration[4.2]
  def change
    remove_column :batches, :processed_at
  end
end
