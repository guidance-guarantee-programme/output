class AddUploadedAtToBatches < ActiveRecord::Migration
  def change
    add_column :batches, :uploaded_at, :datetime
  end
end
