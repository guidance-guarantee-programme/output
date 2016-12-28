class RemovePermissionsDefaultValue < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :permissions, :string, default: nil
  end
end
