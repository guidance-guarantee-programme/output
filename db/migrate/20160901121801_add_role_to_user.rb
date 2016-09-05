class AddRoleToUser < ActiveRecord::Migration
  def change
    add_column :users, :role, :string, default: '', null: false
    execute "UPDATE users SET role = '#{User::ADMIN}' where admin"
    remove_column :users, :admin
  end
end
