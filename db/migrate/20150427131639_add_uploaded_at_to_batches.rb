class AddUploadedAtToBatches < ActiveRecord::Migration[4.2]
  def change
    add_column :batches, :uploaded_at, :datetime
  end
end
