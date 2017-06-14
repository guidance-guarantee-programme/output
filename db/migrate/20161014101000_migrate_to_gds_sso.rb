class MigrateToGdsSso < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :name, :string, default: '', null: false
    execute "UPDATE users SET name = first_name || ' ' || last_name"

    add_column :users, :uid, :string, default: '', null: false
    add_column :users, :organisation_slug, :string, default: '', null: false
    add_column :users, :organisation_content_id, :string, default: '', null: false
    add_column :users, :permissions, :string, default: '', null: false
    add_column :users, :remotely_signed_out, :boolean, default: false
    add_column :users, :disabled, :boolean, default: false
  end
end
