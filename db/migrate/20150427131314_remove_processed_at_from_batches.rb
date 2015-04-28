class RemoveProcessedAtFromBatches < ActiveRecord::Migration
  def change
    remove_column :batches, :processed_at
  end
end
