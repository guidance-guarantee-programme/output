class CreateBatches < ActiveRecord::Migration
  def change
    create_table :batches do |t|
      t.datetime :processed_at

      t.timestamps null: false
    end
  end
end
