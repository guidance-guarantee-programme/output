class RemoveUsersNullConstraints < ActiveRecord::Migration
  def change
    change_column :users, :name, :string, default: '', null: true
    change_column :users, :organisation_slug, :string, default: '', null: true
    change_column :users, :organisation_content_id, :string, default: '', null: true
    change_column :users, :permissions, :string, default: '', null: true
  end
end
